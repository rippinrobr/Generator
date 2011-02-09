class PropertyInfo
  attr_accessor :name, :data_type, :had_one_non_number, :had_one_float, :unique_content

  def initialize(name, data_type=nil) 
    @name = name
    @had_one_non_number = false
    @had_one_float = false
    @unique_content = []
    @data_type = data_type
  end

  def to_s
    "property.name: #{@name} property.data_type: #{@data_type} "
  end
end
