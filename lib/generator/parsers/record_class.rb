class RecordClass
  attr_accessor :properties, :name, :create_service_class, :has_at_least_one_class_property

  def initialize(name='')
    @properties = []
    @name = name
    @create_service_class = true
  end

  def check_for_classes_to_create
    classes = []
    @properties.each do |prop|
      if prop.data_type == "class" || prop.data_type == "array"
        classes << prop
      end
    end

    classes
  end

  def to_s
   ["name: #{name}", "create_service_class: #{@create_service_class}"] | properties.each { |p| puts "\t#{p.to_s}" }
  end
end
