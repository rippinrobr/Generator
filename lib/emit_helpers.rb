require File.join(File.dirname(__FILE__), "../win32/libs/emit/model_generator")
require File.join(File.dirname(__FILE__), "../win32/libs/emit/generate_assembly")

module Generator
  module EmitHelpers
    def EmitHelpers.emit_models(params)
      @params = params
      @domain_to_model = Hash.new
      gen_assembly = GenerateAssembly.new params[:options][:assembly], 1
      @model_gen   = AssemblyModelGenerator.new gen_assembly 
      params[:service].get_views.each{ |e| emit_model(e) }
      gen_assembly.write_dll params[:model_output_dir]
      
      puts "@domain_to_model => #{@domain_to_model}"
      [@domain_to_model, @domain_classes_to_create] 
    end

    def EmitHelpers.emit_model(view_obj)
	elements = @params[:service].get_elements_in_view(view_obj.id)
	model_type, domains_to_create = @model_gen.generate(view_obj.name, elements)
	index = domains_to_create.length-1

	@domain_to_model[domains_to_create[index]] = []
	domains_to_create.each { |dtc|  
	  @domain_to_model[domains_to_create[index]] = @domain_to_model[domains_to_create[index]] | get_elements_by_table(dtc, elements) 
	}
        @domain_classes_to_create = @domain_classes_to_create | domains_to_create
    end    

    def EmitHelpers.get_elements_by_table(table, elements)
      elems = []
      elements.each { |e| elems.push e unless e.table_name != table } unless elements.nil?
      elems
   end
  end
end
