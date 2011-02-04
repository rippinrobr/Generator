require File.join(File.dirname(__FILE__), "../languages/model_generator")
require File.join(File.dirname(__FILE__), "../languages/domain_src_generator")

module Generator
  module SrcHelpers
    def SrcHelpers.gen_src_models(params)
      @params = params
      @domain_to_model = Hash.new
      @model_gen   = ModelGenerator.new 

      params[:service].get_views.each{ |e| gen_src_model(e) }
      [@domain_to_model, @domain_classes_to_create] 
    end

    def SrcHelpers.gen_src_model(view_obj)
      eiv_param = view_obj.id 
      eiv_param = view_obj if @params[:options][:input_type] == "text"
      elements = @params[:service].get_elements_in_view(eiv_param)
      model_type, domains_to_create = @model_gen.generate(@class_def, @options)
      @domain_to_model[domains_to_create] = @params[:service].get_elements_in_view(0)
      @domain_classes_to_create << domains_to_create
    end    
  end
end
