class OutputSettings
  attr_accessor :assembly_name, :model_namespace, :model_output_dir, 
	  :domain_output_dir, :source, :import_namespaces, :service_class,
	  :create_domain_src, :model_type, :language, :class_def, 
	  :domain_namespace, :input_file

  def initialize(params)
    @source     = params.source
    @model_type = params.model_type
    @language   = params.language
    @class_def  = params.class_def
  end  

end
