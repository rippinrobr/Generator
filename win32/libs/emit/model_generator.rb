require File.dirname(__FILE__) + '/../../../lib/string'
require File.dirname(__FILE__) + '/../../../languages/c_sharp/helpers'
require File.dirname(__FILE__) + '/base_generator'
require File.join(File.dirname(__FILE__) , '../CodeGeneration')

class AssemblyModelGenerator
  include BaseGenerator
  include System::Reflection
  include System::Reflection::Emit
  include CSharpHelpers

  def initialize(asm)
    @asm = asm
  end

  def generate(class_name, fields_to_gen)
    class_obj = gen_class_type("Models", class_name)
    tables = create_properties(class_obj, fields_to_gen)
    model_type = class_obj.CreateType
    puts "Done!"

    [ model_type, tables ]
  end

  private
  def create_properties(class_obj, fields_to_gen)
    tables = []
    fields_gend = []

    fields_to_gen.each do |g|
	if g.class.to_s == "Array"
	  field_type = get_type(g[1].to_s, true)
    	  field_ref = @asm.define_property(class_obj, g[0].clean_name.camelize, field_type)
	else
	  tables.push(g.table_name) unless( tables.include?(g.table_name))
	  field_type = get_type(g.field_type.to_s, g.elements_to_views.first.required)
	  field_to_gen = g.field_name.clean_name.camelize
	  if fields_gend.include?(field_to_gen)
	    field_to_gen = "#{g.table_name.clean_name.camelize}#{field_to_gen}"
	  end
	  fields_gend.push field_to_gen
    	  field_ref = @asm.define_property(class_obj, field_to_gen, field_type)
	end
    end

    tables
  end
end
