require "generator/models/domain_src_settings"
require "generator/parsers/read_raw_input"
require "generator/languages/model_generator"
require "generator/languages/domain_src_generator"

module Generator
  class Engine
    attr_accessor :class_def, :child_classes

    def initialize(options, output=STDOUT)
      @options = options
      @output = output
      @domain_classes_to_create = []
      @child_classes = []
      @domain_to_model = Hash.new

      parse_input_file
      raise "#{@options[:source_file]} doesn't exist!" if @class_def.nil?
      @model_gen = ModelGenerator.new
    end

    def create_models
      create_model @class_def
    end

    def create_service_classes(libs_to_import=[])
      @options[:model_name] = @class_def.name 
      service_settings = DomainSrcSettings.new @class_def.name, @options, @class_def.properties
      GenericDomainSrcGenerator.new(service_settings).generate_code
    end

  private 
    def create_model(view_obj)
      model_type, domains_to_create = @model_gen.generate(@class_def, @options)
      puts "[text_code_gen.create_model] model_type: #{model_type.class}"
      @domain_classes_to_create << domains_to_create
      [model_type]
    end

    def parse_input_file
      if File.exists?(@options[:source_file])
        @reader = ReadRawInput.new :text, @options[:source_file],
                                      @options[:language], 
				      @options[:header]
        @class_def = @reader.read
      end
    end
  end
end
