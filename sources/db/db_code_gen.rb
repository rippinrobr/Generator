require File.join(File.dirname(__FILE__), "os")
require File.join(File.dirname(__FILE__), "emit_helpers")
require File.join(File.dirname(__FILE__), "src_helpers")
require File.join(File.dirname(__FILE__), "parsers/record_class")
require File.join(File.dirname(__FILE__), "parsers/property_info")
require File.join(File.dirname(__FILE__), "../win32/libs/elements_service")
require File.join(File.dirname(__FILE__), "../win32/libs/emit/model_generator")
require File.join(File.dirname(__FILE__), "../win32/libs/emit/generate_assembly")
require File.join(File.dirname(__FILE__), "../win32/libs/elements_service")
require File.join(File.dirname(__FILE__), "../languages/model_generator")
require File.join(File.dirname(__FILE__), "../languages/domain_src_generator")
require File.join(File.dirname(__FILE__), "models/model_class_definition")
require File.join(File.dirname(__FILE__), "models/domain_src_settings")

module Generator
  class Engine
    include Generator::EmitHelpers

    def initialize(options, output=STDOUT)
      @options = options
      @output = output
    
      @domain_classes_to_create = [] 
      @domain_to_model = Hash.new
      @elements_service = ElementsService.new
    end

    def create_models
      params = Hash.new
      params[:options] = @options
      params[:service] = @elements_service

      if @options[:model_output] == "emit" 
	if OS::has_dotnet? #<--------- That needs to be am I running IronRuby?
	  @domain_to_model, @domain_classes_to_create = EmitHelpers.emit_models params
        else
	  puts "Cannot emit a DLL without .NET/Mono installed."
	  exit -1
        end
      else
	model_gen = ModelGenerator.new
	params[:service].get_views.each do |e|
          rec = RecordClass.new e.name.clean_name.singularize
          table_name = e.name.gsub(/\s*[M|m]odel/,'').clean_name
	  elements = params[:service].get_elements_in_view(e.id)
          elements.each do |d| 
	    rec.properties << PropertyInfo.new(d.field_name.clean_name, d.field_type) 
	  end 
	  print "Creating Model class for #{rec.name}..."
          model_type, domains_to_create = model_gen.generate(rec, @options)
	  puts "Done!"
	  @domain_to_model[table_name] = get_elements_by_table(table_name, elements)
	end	
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
   def src_model(view_obj, service)
     @model_gen = ModelGenerator.new
     class_def = RecordClass.new view_obj.name.clean_name
     
     elements = service.get_elements_in_view(view_obj.id)
     service.get_elements_in_view(view_obj.id).each do |elem|
       class_def.properties << PropertyInfo.new(elem.field_name.clean_name, elem.field_type)
     end
   
     model_type, domains_to_create = @model_gen.generate(class_def, @options)
     @domain_to_model[domains_to_create] = @elements_service.get_elements_in_view(0)
     @domain_classes_to_create << domains_to_create 
   end

   def convert_hash_to_prop_info_array(domain_name, the_hash)
     raise "the_hash is nil" unless !the_hash.nil?

     props = []
     the_hash.each { |name, type| props << Prop.new(domain_name, name, type) }
     props
  end

   def get_elements_by_table(table, elements)
     elems = []
     elements.each { |e| elems.push e unless e.table_name != table } unless elements.nil?
     elems
   end
  end
end
