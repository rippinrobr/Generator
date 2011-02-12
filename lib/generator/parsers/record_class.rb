class RecordClass
  attr_accessor :properties, :name, :create_service_class

  def initialize(name='')
    @properties = []
    @name = name
    @create_service_class = true
  end

  def to_s
    properties.each { |p| puts "\t#{p.to_s}" }
  end
end
