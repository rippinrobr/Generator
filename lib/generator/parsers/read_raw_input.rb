require 'generator/utils/string'
require 'generator/parsers/record_class'
require 'generator/parsers/property_info'
require 'pathname'
require 'csv'

class ReadRawInput
  attr_accessor :input_type, :location

  def initialize(input_type, location, language, has_headings=false, delim=',')
   # load "lib/generator/languages/#{language}/string.rb"
    require "generator/languages/#{language}/string"

    @input_type = input_type
    @location = location
    @has_headings = has_headings
    @delim = delim

    @reader = {}
    @reader[:text] = read_file

    @record_class = RecordClass.new
  end

  def read
    @reader[@input_type]
  end

  private
  def read_file
    @record_class = RecordClass.new
    
    @record_class.name = File.basename(@location).to_s.clean_name
    @record_class.name = @record_class.name.sub(".","_")
    
    File.open(@location, "r") do |txt|
      first_time_through = true

      while line=txt.gets do
	fields = line.to_s.chomp.split @delim
        if first_time_through
	  configure_properties fields
	  raise "No Properties found" unless @record_class.properties.length > 0
	  first_time_through = false
	else
          check_col_type fields	
	end 
      end 
    end
    check_for_bools
    @record_class
  end

  def check_col_type fields
    counter = 0
    fields.each do |f|
      if !@record_class.properties[counter].nil?
        @record_class.properties[counter].unique_content.push f unless @record_class.properties[counter].unique_content.include?(f)
        if !@record_class.properties[counter].had_one_non_number
	  if f.to_i == 0 && f.to_f == 0 && f.to_s != '0'
	    @record_class.properties[counter].had_one_non_number = true
	    @record_class.properties[counter].data_type = "string"
	  else
	    int_val = f.to_i
	    float_val = f.to_f
	    if int_val != float_val
	      @record_class.properties[counter].data_type = "float"
            else
	      @record_class.properties[counter].data_type = "int"
	    end
          end
        end
        counter += 1
      end
     end
    end

  def check_for_bools
    @record_class.properties.each do |prop|
      if prop.data_type != "float"
	if prop.unique_content.length == 2 
	   if prop.unique_content.include?(0) && prop.unique_content.include?(1) 
	      prop.data_type == "bool"
	   end
	   if prop.unique_content.include?("true") && prop.unique_content.include?("false") 
	     prop.data_type == "bool"
	   end
	end
      end
    end
  end

  def configure_properties fields
    if @has_headings
      fields.each do |field|
       	@record_class.properties.push PropertyInfo.new(field.clean_name, field)
      end
    else
      (1..fields.length).each do |i| 
         original_name = PropertyUtils::generate_name(i)
	 @record_class.properties.push PropertyInfo.new(original_name, original_name)
      end	
    end	
  end
end
