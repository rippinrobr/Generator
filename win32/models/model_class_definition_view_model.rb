require File.join(File.dirname(__FILE__), "base_view_model")
require File.join(File.dirname(__FILE__), "/../../lib/models/model_class_definition")

class ModelClassDefinitionViewModel < BaseViewModel

  def initialize(win)
    super(win)

    @submit_handlers = []
  end
  
  def add_submit_handler(&block)
    @submit_handlers.push block
  end

  def load_form(params)
    @load_params = params

    classNameTxtBox.Text = @load_params.class_def.name 
    grid = Grid.new
    col1 = ColumnDefinition.new

    grid.ShowGridLines = true
    col1.Width         = GridLength.new(100)

    grid.ColumnDefinitions.Add(col1)
    grid.ColumnDefinitions.Add(ColumnDefinition.new())

    row_count = 0
    @load_params.class_def.properties.each do |prop|
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
  end

  def save_class_definition(s,e) 
    @load_params.class_def.properties = Hash.new
    @load_params.class_def.name = classNameTxtBox.Text

    grid = propertiesStackPanel.Children[0]
    counter = 1;
    is_data_type = true

    data_type = ''
    grid.Children.each do |c|
      if is_data_type
	data_type = c.Text
      else
        @load_params.class_def.properties[c.Text] = data_type
      end
      is_data_type = !is_data_type
    end
    @submit_handlers.each { |h| h.call(@load_params) }
  end
end
