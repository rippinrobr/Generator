class RecordClass
  attr_accessor :properties, :name, :create_service_class, :has_an_array_property

  def initialize(name='')
    @properties = []
    @name = name
    @create_service_class = true
    @has_an_array_property = false
  end

  def to_s
    properties.each { |p| puts "\t#{p.to_s}" }
  end
end
