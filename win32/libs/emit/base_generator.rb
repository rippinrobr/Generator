require File.join(File.dirname(__FILE__), "../../../lib/string")
require File.join(File.dirname(__FILE__), "../../../languages/c_sharp/string")

module BaseGenerator
  def gen_class_type(namespace, name, interface=nil)
    print "Creating the class #{name.clean_name.camelize}...."
    @asm.define_class "#{namespace}.#{name.clean_name.camelize}"#, interface
  end
end
