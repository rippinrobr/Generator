require File.join(File.dirname(__FILE__), "base_view_model")
require File.join(File.dirname(__FILE__), "/../../lib/models/output_settings")
require File.join(File.dirname(__FILE__), "../libs/elements_service")
require File.join(File.dirname(__FILE__), "../../lib/cmd_line")

class OutputViewModel < BaseViewModel

  def initialize(win) 
    super(win)
    @submit_handlers = []
  end

  def add_submit_handler(&block)
    @submit_handlers.push block
  end
  
  def load_form(load_params)
    @load_params = load_params

    if !@load_params.class_def.nil? 
      assemblyNameTxtBox.Text = @load_params.class_def.name
      modelNamespaceTxtBox.Text = "#{@load_params.class_def.name}.Models"
      domainNamespaceTxtBox.Text = "#{@load_params.class_def.name}.Services"
    end

    generateBtn.click.add method(:generate_code)
  end	  

  private
  def generate_code(s,e)
    @window.close
    
    # this part needs to be cleaned up a bit but it will work for now
    #settings = OutputSettings.new @load_params

    #if @load_params.source == :text
    #  settings.service_class = TextElementsService.new(@load_params.class_def)
    #else
    #  settings.service_class = ElementsService.new
    #end
    #settings.model_namespace = modelNamespaceTxtBox.Text
    #settings.assembly_name = assemblyNameTxtBox.Text
    #settings.model_namespace = modelNamespaceTxtBox.Text
    #settings.domain_namespace = domainNamespaceTxtBox.Text
    #settings.model_output_dir = dllOutputDirTxtBox.Text
    #settings.domain_output_dir = domainSrcOutputDirTxtBox.Text
    #settings.domain_output_dir += "/" unless settings.domain_output_dir.ends_with("\\|/")
    #import_namespace_vals = importNamespacesTxtBox.Text
    #settings.import_namespaces = import_namespace_vals.split /,/ 

    args = ["-i"]
    args << @load_params.source.to_s
    if @load_params.source == :text
      args << "-sf"
      args << @load_params.input_file 
    end
    args << "-m"
    args << @load_params.model_type.to_s

    args << "-l"
    args << @load_params.language.to_s
    args << "-hd" if @load_params.has_header 
  
    if assemblyNameTxtBox.Text
      args << "-a"
      args << assemblyNameTxtBox.Text
    end
    
    if modelNamespaceTxtBox.Text
      args << "-mn"
      args << modelNamespaceTxtBox.Text
    end 

    if domainNamespaceTxtBox.Text
      args << "-sn"
      args << domainNamespaceTxtBox.Text
    end 

    if dllOutputDirTxtBox.Text
      args << "-mod"
      args << dllOutputDirTxtBox.Text
    end

    if domainSrcOutputDirTxtBox.Text
      args << "-sod" 
      args << domainSrcOutputDirTxtBox.Text
    end

    if importNamespacesTxtBox.Text != ''
      args << "-imp" 
      args << importNamespacesTxtBox.Text
    end

    
    puts "args => #{args}"

    cmd_line = Generator::CmdLine.new STDOUT
    cmd_line.run args
  end
end
