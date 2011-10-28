class PropertyInfo
  attr_accessor :name, :data_type, :had_one_non_number, 
    :had_one_float, :unique_content, :array_class_name, :original_name,
    :owner_class, :source_property, :data_source_field_name

  def initialize(name, original_name='', data_type=nil) 
    @name = name
    @original_name = original_name
    @had_one_non_number = false
    @had_one_float = false
    @unique_content = []
    @data_type = data_type
    @data_source_field_name = nil
  end

  def to_s
    "property.name: #{@name} property.data_type: #{@data_type} property.owner_class: #{@owner_class} property.source_property: #{@source_property}\nproperty.original_name: #{@original_name} property.data_source_field_name: #{@data_source_field_name}"
  end
end
