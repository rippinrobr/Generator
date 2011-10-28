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
    
    if @properties.length > 1
      @properties.each do |prop|
        if prop.data_type == "class" || prop.data_type == "array"
          prop.owner_class = @name
          classes << prop
        end
      end
    end

    classes
  end

  def find_child_class_by_name(child_class_name)
    puts "in find_child_class_by_name"
    @child_classes.map do |cls|
      if cls.name == child_class_name
        #puts "found a match! #{cls}"
        return cls
      end
    end
    nil
  end

  def to_s
   ["name: #{name}", "create_service_class: #{@create_service_class}"] | properties.each { |p| puts "\t#{p.to_s}" }
  end
end
