class RecordClass
  attr_accessor :properties, :name, :create_service_class, 
    :has_at_least_one_class_property, :child_classes, :parent_class,
    :parent_column_id

  def initialize(name='')
    @properties = []
    @child_classes = []
    @name = name
    @create_service_class = true
    @parent_class = nil
  end

  def check_for_classes_to_create
    classes = []
    @properties.each do |prop|
      if prop.data_type == "class" || prop.data_type == "array"
        prop.owner_class = @name
        classes << prop
      end
    end

    classes
  end

  def to_s
   ["name: #{name}", "create_service_class: #{@create_service_class}"] | properties.each { |p| puts "\t#{p.to_s}" }
  end
end
