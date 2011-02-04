require File.join(File.dirname(__FILE__), "models/model_class_definition")
require File.join(File.dirname(__FILE__), "models/prop")

class TextProperty
  #table_name
end

class TextElementsService
  def initialize(model_def)
    @model_def = model_def
  end

  def get_views
    [@model_def]
  end

  def get_elements_in_view(id)
    create_props_array
  end

  def get_properties(type)
    create_props_array
  end

  def dispose
  end
  private 
  def create_props_array
    props = []
    @model_def.properties.each do |k|
      props.push Prop.new(@model_def.name, k.name, k.data_type) unless k.nil?
    end

    props
  end
end
