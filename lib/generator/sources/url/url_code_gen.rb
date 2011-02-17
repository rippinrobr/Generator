require_relative '../../utils/url_manager'
require_relative '../../parsers/record_class'
require_relative '../../parsers/property_info'
require_relative '../../utils/string'
require_relative '../../languages/model_generator'
require_relative '../../languages/domain_src_generator'
require_relative '../../models/domain_src_settings'

module Generator
  class Engine
    
    def initialize(options, url_mgr = Generator::Utils::UrlManager.new() , output=STDOUT)
      load "lib/generator/languages/#{options[:language]}/string.rb"

      @options = options
      @output = output
      @url_mgr = url_mgr
      @model_gen = ModelGenerator.new

      load_parser
    end

    def create_models
      @classes_to_create = get_model_classes_to_create(@res.body)
      more_classes_to_create = []
      @classes_to_create.each do |cls|
        cls.properties.each do |prop|
          if prop.data_type == "class" && !@classes_to_create.include?(prop.name) 
            new_prop_class = RecordClass.new
            new_prop_class.name = "#{prop.name}_model"
            new_prop_class.create_service_class = false
            more_classes_to_create << convert_hash_to_class(prop.unique_content[0], new_prop_class) 
          end
        end
      end
      @classes_to_create = @classes_to_create | more_classes_to_create
      @classes_to_create.each { |c| @model_gen.generate(c, @options) }
    end
   
    def create_service_classes
      @classes_to_create.each do |cls|
        if cls.create_service_class
          service_class_name = @options[:service_class_name]
          service_class_name = cls.name if service_class_name.nil? || service_class_name == ''
          @options[:model_class_name] = cls.name if @options[:model_class_name].nil? || @options[:model_class_name] == ''

          service_settings = DomainSrcSettings.new cls.name, @options, cls.properties
          GenericDomainSrcGenerator.new(service_settings).generate_code
        end
      end 
    end

    def parser_name
      return nil if @parser.nil?
      @parser.name 
    end 

   private
    def get_model_classes_to_create(data)
      parsed_data = @parser.parse data.gsub(/\\|^\"|\"$/,'')
      class_def = convert_hash_to_class parsed_data, RecordClass.new
      class_def.name = @options[:model_class_name] unless @options[:model_class_name].nil? || @options[:model_class_name] == ''
      check_data_types class_def
    end

    def load_parser
      @res = @url_mgr.get_page @options[:url]
      content_type = @res.content_type.gsub(/\//,'_')

      begin 
        load "lib/generator/parsers/#{content_type}_parser.rb"   
        @parser = Generator::Parsers::InputParser.new 
      rescue LoadError => e
        @output.puts "Content Type '#{content_type}' does not have a corresponding parser" 
      end
    end

    def parse_json(text)
    end
  
    def convert_hash_to_class(data, class_def)
      class_def.name = set_class_name if class_def.name == '' || class_def.name.nil?
      data.keys.each do |field| 
        prop = PropertyInfo.new field.dup().clean_name
        prop.unique_content << data[field] unless prop.unique_content.include?(data[field])
        class_def.properties << prop
      end
      
      class_def 
    end

    def check_data_types(class_def)
      class_definitions = []
      
      class_def.properties.each do |prop|
        if prop.unique_content.count == 1 && !prop.unique_content[0].is_a?(Array)
          prop.data_type = get_field_type(prop.unique_content[0])
        else
          prop.data_type = "array"
          array_class_definition = create_array_record_class(prop.unique_content[0], "#{prop.name}_model".clean_name)
 	  prop.array_class_name = array_class_definition.name
          class_definitions << array_class_definition
        end
      end 

      class_definitions << class_def
    end

    def create_array_record_class(values, field_name="rec_class")
      arr_rec_class_def = RecordClass.new
      arr_rec_class_def.name = field_name.clean_name
      arr_rec_class_def.create_service_class = false

      values[0].keys.each do |k|
        vals = []
        values.each { |rec| vals << rec[k] }
        arr_rec_class_def.properties << PropertyInfo.new(k.clean_name, determine_field_type(vals))
      end

      arr_rec_class_def 
    end

    def determine_field_type(values) 
      field_type = "string"

      values.each do |val|
        field_type = get_field_type(val)
        return field_type if ["string","array"].include?(field_type)
      end
	
      field_type
    end

    def get_field_type(data)
      if data.is_a? String
        handle_string_data data
      elsif data.is_a? Array
        "array"
      else  
        "class"
      end
    end

    def handle_string_data(data) 
      if data.nil? || !data.is_a_number?
        "string"
      elsif data.to_i == data.to_f 
        "int"
      else
        "float"
      end
    end

    def set_class_name
      return "my_class" if @options[:model_class_name].nil?
      @options[:model_class_name].clean_name
    end
  end
end
