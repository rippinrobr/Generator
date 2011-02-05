require File.join(File.dirname(__FILE__), '../languages/domain_src_generator')
require File.join(File.dirname(__FILE__), '../languages/model_generator')
require 'lib/models/domain_src_settings'
require 'lib/os'

# .NET is required for this so the platform needs to be windows or have
# MONO installed.
if OS::has_dotnet?
  Dir['win32/libs/emit/*.rb'].each { |file| require file.gsub(/\.rb/,'') }
end

class CodeGen
  
  def initialize(settings)
    Dir["languages/#{settings.language}/*.rb"].each { |file| require file.gsub(/\.rb/,'') }
    @settings = settings
    @domain_classes_to_create = [] 
    @domain_to_model = Hash.new

    display_beginning_banner
  end

  def create_models
    if @settings.model_type == :emit && OS::has_dotnet?
      @ga2       = GenerateAssembly.new @settings.assembly_name, 1
      @model_gen = AssemblyModelGenerator.new @ga2 
    elsif @settings.model_type == :src
      @model_gen = ModelGenerator.new #unless @settings.language != :c_sharp
    end

    @models = @settings.service_class.get_views
    @models.each { |e| create_model(e) }
  end

  # Creates each individual model for the assembly and queues up 
  # the domain level classes that are need to support the models
  # THIS NEEDS TO BE CLEANED UP
  def create_model(view_obj)
    if @settings.model_type == :emit
      if @settings.source == :db 
        elements = @settings.service_class.get_elements_in_view(view_obj.id)
        model_type, domains_to_create = @model_gen.generate(view_obj.name, elements)

	index = domains_to_create.length-1
	@domain_to_model[domains_to_create[index]] = []
	domains_to_create.each { |dtc|  
	  @domain_to_model[domains_to_create[index]] = @domain_to_model[domains_to_create[index]] | get_elements_by_table(dtc, elements) 
	}
        @domain_classes_to_create = @domain_classes_to_create | domains_to_create
      else
        elements = @settings.service_class.get_elements_in_view(view_obj.id)
        model_type, domains_to_create = @model_gen.generate(@settings.class_def.name, elements) 

	@domain_classes_to_create.push domains_to_create[0]
        @domain_to_model[domains_to_create[0]] = @settings.service_class.get_elements_in_view(0)
      end
    else
      if @settings.source == :db 
	model = ModelClassDefinition.new
	model.convert_from_view(view_obj)
	model, domains_to_create = @model_gen.generate(model, @settings)

	domains_to_create.each do |dtc|  
	  # Add a method that will take the model.properties hash that will convert it to an array
	  # of propertyinfo classes
	  @domain_to_model[dtc] = get_elements_by_table(dtc, convert_hash_to_prop_info_array(dtc, model.properties))
	end

	@domain_classes_to_create.push domains_to_create
      else
        elements = @settings.service_class.get_elements_in_view(view_obj.id)
        domains_to_create = @model_gen.generate(@settings.class_def, @settings)
	@domain_classes_to_create.push domains_to_create
        @domain_to_model[domains_to_create[0].name] = @settings.service_class.get_elements_in_view(0)
      end
    end
  end

  def create_domain_classes_src(namespaces_to_import=[])
    @domain_to_model.keys.each do |class_name|
	if !class_name.nil? && class_name.to_s != '' 
	  @domain_src_settings = DomainSrcSettings.new class_name, @settings, @domain_to_model[class_name]
          GenericDomainSrcGenerator.new(@domain_src_settings).generate_code
	end
    end
  end

  def dispose()
    @settings.service_class.dispose

   display_ending_banner
  end

  def save_dll
    @ga2.write_dll @settings.model_output_dir
  end

 private
   def convert_hash_to_prop_info_array(domain_name, the_hash)
     raise "the_hash is nil" unless !the_hash.nil?

     props = []
     the_hash.each { |name, type| props << Prop.new(domain_name, name, type) }
     props
   end

   def display_beginning_banner
     puts ""
     puts "######################################################################"
     puts ""
     puts "Creating assembly: #{@settings.assembly_name} and saving it to #{@settings.model_output_dir}"
     puts "The models will be in the #{@settings.model_namespace} namespace."
     puts "The source used to generate the code: #{@settings.source}."
     puts "The source files will be in the #{@settings.domain_output_dir} directory."
     puts ""
   end

   def display_ending_banner
     puts ""
     puts "######################################################################"
     puts ""
   end

   def get_elements_by_table(table, elements)
     elems = []
     elements.each { |e| elems.push e unless e.table_name != table } unless elements.nil?
     elems
   end
end
