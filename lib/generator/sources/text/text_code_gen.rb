require_relative "../../models/model_class_definition"
require_relative "../../models/domain_src_settings"
require_relative "../../parsers/read_raw_input"
require_relative "../../languages/model_generator"
require_relative "../../languages/domain_src_generator"

module Generator
  class Engine
    def initialize(options, output=STDOUT)
      @options = options
      @output = output
      @domain_classes_to_create = []
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
      @domain_classes_to_create << domains_to_create
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
