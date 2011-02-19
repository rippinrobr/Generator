class PropertyInfo
  attr_accessor :name, :data_type, :had_one_non_number, :had_one_float, :unique_content, :array_class_name, :original_name

  def initialize(name, original_name='', data_type=nil) 
    @name = name
    @original_name = original_name
    @had_one_non_number = false
    @had_one_float = false
    @unique_content = []
    @data_type = data_type
  end

  def to_s
    "property.name: #{@name} property.data_type: #{@data_type} "
  end
end
