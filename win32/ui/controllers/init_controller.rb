require 'PresentationFramework'
require 'PresentationCore'
require File.dirname(__FILE__) + '/../code_gen'
require File.join(File.dirname(__FILE__), 'base_controller')
require File.join(File.dirname(__FILE__), '../models/init_view_model')
include System::Windows
include System::Windows::Controls

class InitController < BaseController
  attr_accessor :assembly_name, :model_namespace, :domain_src_output_dir, 
	  :dll_output_dir, :import_namespaces 

  def initialize view_path
    super(view_path)

    @vm = InitViewModel.new 
    @vm.assembly_name = 'BaseballStats'
    @vm.model_namespace = 'BaseballStats.Models'
    @vm.domain_src_output_dir = 'c:/Code/Research/ironrubyassemblybuilder/IRCDemo/BaseballStatsSite/Services/'
    @vm.dll_output_dir = 'c:/temp'
    @vm.import_namespaces = "System,System.Linq,BaseballStats.Models,BaseballStatsSite.Storage"
    @vm.gen_source = 'DB'

    init_form
  end

  private
  def init_form
    assemblyNameTxtBox.Text       = @vm.assembly_name
    modelNamespaceTxtBox.Text     = @vm.model_namespace
    domainSrcOutputDirTxtBox.Text = @vm.domain_src_output_dir
    dllOutputDirTxtBox.Text       = @vm.dll_output_dir
    importNamespacesTxtBox.Text   = @vm.import_namespaces

    generateBtn.click.add method(:start_gen)
  end

  def start_gen(s,e)
    @vm.assembly_name         = assemblyNameTxtBox.Text
    @vm.model_namespace       = modelNamespaceTxtBox.Text
    @vm.domain_src_output_dir = domainSrcOutputDirTxtBox.Text
    @vm.dll_output_dir        = dllOutputDirTxtBox.Text
    @vm.import_namespaces     = importNamespacesTxtBox.Text

    @window.close

    puts ""
    puts "######################################################################"
    puts ""
    puts "Creating assembly: #{@vm.assembly_name}"
    puts "The models will be in the #{@vm.model_namespace} namespace."
    puts "The source used to generate the code #{@vm.gen_source}."
    puts "The source files will be in the #{@vm.domain_src_output_dir} directory."
    puts ""

    cg = CodeGen.new @vm.assembly_name,
	    @vm.model_namespace,
	    ElementsService.new,
	    @vm.domain_src_output_dir

    cg.create_models
    cg.save_dll @vm.dll_output_dir
    cg.create_domain_classes_src @vm.import_namespaces.split(',')
    puts ""
  puts "######################################################################"
  puts ""
  end
end
