require 'System.Core'
require File.join(File.dirname(__FILE__), '../CodeGeneration')

#----------------------------------------------------------------------------------
# This class wraps the .NET classes used to create the assembly.
#----------------------------------------------------------------------------------
class GenerateAssembly
  include System
  include System::Reflection
  include System::Reflection::Emit

  attr_accessor :assembly

  #----------------------------------------------------------------------------------
  # In the constructor we initialize the Assembly object and the AssemblyBuilder 
  # object, @mod_builder. @mod_builder will be used to create a class or interface 
  # in our assembly.
  #----------------------------------------------------------------------------------
  def initialize(namespace, version)
    @namespace = namespace
    @asm = AssemblyName.new 
    @asm.Version = Version.new version, 0, 0, 0
    @asm.Name = namespace
    # atually creates the dynamic assembly and then the dynamic module 
    @assembly = AppDomain.CurrentDomain.DefineDynamicAssembly(@asm, 
				   AssemblyBuilderAccess.RunAndSave)
    @dll_name = "#{@asm.Name}.dll"
    @mod_builder = @assembly.DefineDynamicModule("#{@asm.Name}", 
						 @dll_name, 
						 false)
  end

  #----------------------------------------------------------------------------------
  # Creates the class type and returns it to the calling method.  Any fields, properties,
  # or methods will need the object.  If no interface is need the simple call is made 
  # creating the type object as a Public class.  The first two parameters are the 
  # same in both DefineType calls.  In the cases where we are  implementing an interface
  # we need to pass in the Object constructor and the interface type we are implementing
  #----------------------------------------------------------------------------------
  def define_class(class_name, interface=nil)
    if interface.nil?
      @mod_builder.DefineType("#{@namespace}.#{class_name}", TypeAttributes.Public)
    else
      types = System::Collections::Generic::List.of(Type).new
      types.add interface

      tb = @mod_builder.DefineType("#{@namespace}.#{class_name}", 
				   TypeAttributes.Public,
    				   System::Object.to_clr_type,
				   types.ToArray)

      tb
    end
  end

  def define_interface(inter_name)
    @mod_builder.DefineType("#{@namespace}.#{inter_name}", TypeAttributes.Interface | TypeAttributes.Abstract )
  end

  #-----------------------------------------------------------------------------------
  # Creates the fields in the model classes.  The tb parameter is the class type object 
  # that the field will belong to.  the type parameter is the CLR type that the field
  # should be
  #-----------------------------------------------------------------------------------
  def define_property(tb, name, type, attributes=FieldAttributes.Public)
    private_field = tb.DefineField("_#{name.downcase}", 
				   type, FieldAttributes.Private);
    
    prop = tb.DefineProperty(name, 
			     PropertyAttributes.HasDefault, 
			     type, nil) 

    get_set_attr = MethodAttributes.Public | 
	    	   MethodAttributes.SpecialName | 
		   MethodAttributes.HideBySig
  
    get_method = tb.DefineMethod("get_#{name}", 
		get_set_attr, type, Type.EmptyTypes)    
    prop_il= get_method.GetILGenerator()
    prop_il.Emit(OpCodes.Ldarg_0)
    prop_il.Emit(OpCodes.Ldfld, private_field)
    prop_il.Emit(OpCodes.Ret)

    # Define "set" accessor method for the property.
    set_params = System::Collections::Generic::List.of(Type).new
    set_params.add type
    set_method = tb.DefineMethod("set_#{name}", get_set_attr, nil, 
				 set_params.ToArray)    
    prop_il = set_method.GetILGenerator()
    prop_il.Emit(OpCodes.Ldarg_0);
    prop_il.Emit(OpCodes.Ldarg_1);
    prop_il.Emit(OpCodes.Stfld, private_field);
    prop_il.Emit(OpCodes.Ret);

    # Last, we must map the two methods created above to our PropertyBuilder to 
    # their corresponding behaviors, "get" and "set" respectively. 
    prop.SetGetMethod(get_method);
    prop.SetSetMethod(set_method);
    
    prop	
  end

  #-----------------------------------------------------------------------------------
  # Writes the assembly out to the file system.  
  #-----------------------------------------------------------------------------------
  def write_dll(path=nil)
    @assembly.Save(@dll_name)
    if !path.nil?
     dest_path = "#{path}\\#{@dll_name}"
     puts "Copying #{@dll_name} to #{dest_path}"
     if System::IO::File.exists(dest_path)
       System::IO::File.delete(dest_path)
     end
     System::IO::File.copy(@dll_name, dest_path)
    end 
  end

  private
end
