require 'PresentationFramework'
require 'PresentationCore'
require File.dirname(__FILE__) + '/../code_gen'
require File.dirname(__FILE__) + '/../text_elements_service'
require File.join(File.dirname(__FILE__), 'base_controller')

include System::Windows
include System::Windows::Controls

Dir[File.dirname(__FILE__) + '/../models/*.rb'].each { |file| require file.gsub(/\.rb/,'') }

class ClassEditorController < BaseController
  def initialize view_path, view_model
    super(view_path)
    
    @vm = view_model
    init_form

    @model_def = ModelClassDefinition.new
  end

  private
  def init_form
    dbRb.Checked {
      MessageBox.show "DB"
    }
    textRb.Checked {
      MessageBox.show "Text"
    }
    classNameTxtBox.Text = @vm.name
    grid = Grid.new
    grid.ShowGridLines = true
    col1 = ColumnDefinition.new
    col1.Width = GridLength.new(100)

    grid.ColumnDefinitions.Add(col1)
    grid.ColumnDefinitions.Add(ColumnDefinition.new())

    row_count = 0
    @vm.properties.each do |prop|
       row_def = RowDefinition.new
       row_def.Height = GridLength.new(25)
       grid.RowDefinitions.Add(row_def)

       dataTypeBox = TextBox.new
       dataTypeBox.Text = prop.data_type

       nameBox = TextBox.new
       nameBox.Text = prop.name

       Grid.SetRow(dataTypeBox, row_count)
       Grid.SetColumn(dataTypeBox, 0)

       Grid.SetRow(nameBox, row_count)
       Grid.SetColumn(nameBox, 1)

       grid.Children.Add(dataTypeBox)
       grid.Children.Add(nameBox)

       row_count += 1
    end

    propertiesStackPanel.Children.Add(grid)

    saveClassDefBtn.click.add method(:save_class_definition)
    generateBtn.click.add method(:generate_code)
  end

  def generate_code(s,e)
    @window.close
    assembly_name = assemblyNameTxtBox.Text
    model_namespace = modelNamespaceTxtBox.Text
    dll_output_dir = dllOutputDirTxtBox.Text
    domain_src_output_dir = domainSrcOutputDirTxtBox.Text
    import_namespace = importNamespacesTxtBox.Text
    source = "text"

    puts ""
    puts "######################################################################"
    puts ""
    puts "Creating assembly: #{assembly_name} and saving it to #{dll_output_dir}"
    puts "The models will be in the #{model_namespace} namespace."
    puts "The source used to generate the code: #{source}."
    puts "The source files will be in the #{domain_src_output_dir} directory."
    puts ""
    cg = CodeGen.new assembly_name, 
		model_namespace, 
		TextElementsService.new(@model_def),
		domain_src_output_dir 
		
    cg.create_models
    cg.save_dll dll_output_dir
    cg.create_domain_classes_src import_namespaces ||= [] 
    puts ""
    puts "######################################################################"
    puts ""
  end

  def save_class_definition(s,e) 
    @model_def.name = classNameTxtBox.Text
    
    grid = propertiesStackPanel.Children[0]
    counter = 0;
    prev_key = ''
    grid.Children.each do |c|
      if counter % 2 == 1
	prev_key = c.Text
      else
        @model_def.properties[prev_key] = c.Text 
      end
      counter += 1
    end
    assemblyNameTxtBox.Text = @model_def.name
    modelNamespaceTxtBox.Text = "#{@model_def.name}.Models"
    dllOutputDirTxtBox.Text = "c:/temp"
    domainSrcOutputDirTxtBox.Text = 'c:/temp'
    importNamespacesTxtBox.Text = "System,System.Linq,#{modelNamespaceTxtBox.Text}"

    outputSettingsTab.IsSelected = true
  end
end
