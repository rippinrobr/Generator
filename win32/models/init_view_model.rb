require 'PresentationFramework'
require 'PresentationCore'

class InitViewModel
  attr_accessor :assembly_name, :model_namespace, 
	  :domain_src_output_dir, :dll_output_dir, 
	  :import_namespaces, :gen_source 

  def initialize
  end
end
