class RecordClass
  attr_accessor :properties, :name

  def initialize(name='')
    @properties = []
    @name = name
  end

  def to_s
    properties.each { |p| puts "\t#{p.to_s}" }
  end
end
