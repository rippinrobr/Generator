require_relative "text_elements_service"
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
      @elements_service = TextElementsService.new @class_def
      @model_gen = ModelGenerator.new
    end

    def create_models
      if @options[:model_output].to_s == "emit"
	if OS::has_dotnet?
  	  require_relative "../../lib/generator/herlpers/emit_helpers.rb"
	  params = Hash.new
          params[:options] = @options
          params[:service] = @elements_service
	  params[:options][:input_type] = "db"
	  @domain_to_model, @domain_classes_to_create = Generator::EmitHelpers.emit_models(params)
	end
      else
        @models = @elements_service.get_views
        @models.each { |e| create_model(e) }
      end
    end

    def create_service_classes(libs_to_import=[])
      @domain_to_model.keys.each do |gen_class|
        if !gen_class.nil? && gen_class.to_s != ''
          class_name = "#{gen_class}"
          @options[:model_name] =  @domain_to_model[gen_class][0].table_name
          service_settings = DomainSrcSettings.new class_name, @options, @domain_to_model[gen_class]
          GenericDomainSrcGenerator.new(service_settings).generate_code
        end
      end
    end

  private 
    def create_model(view_obj)
      if @options[:model_output].to_s == "emit"
	elements = @elements_service.get_elements_in_view(view_obj.id)
        model_type, domains_to_create = @model_gen.generate(@class_def.name, elements) 

	@domain_classes_to_create.push domains_to_create[0]
        @domain_to_model[domains_to_create[0]] = @elements_service.get_elements_in_view(0)
      elsif @options[:model_output] = :src
        model_type, domains_to_create = @model_gen.generate(@class_def, @options)
        @domain_to_model[domains_to_create] = @elements_service.get_elements_in_view(0)
        @domain_classes_to_create << domains_to_create
      end
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
