class ModelClassDefinition
   attr_accessor :name, :properties

   def initialize
     @properties = Hash.new
   end

   def id
     @name
   end

   def convert_from_view(view)
     @name = view.name.clean_name
     view.elements_to_views.each do |el|
       @properties[el.element.field_name.clean_name] = el.element.field_type
     end
   end

   def to_s
     str = "class #{@name}\n"
     @properties.keys.each do |prop|
       str += "\t#{@properties[prop]} #{prop}\n" unless prop == ''
     end
     str
   end
end
