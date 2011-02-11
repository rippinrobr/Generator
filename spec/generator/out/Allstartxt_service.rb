#---------------------------------------------------------------------
# Generated on 2011-02-08 18:03:46 -0500 by rob
# Using Generator 0.1.1
#---------------------------------------------------------------------
require './Allstartxt'

class AllstartxtService
  def initialize(gen_source = '')
    @gen_source = gen_source
    @content = []
  end

  def all()
    raise "Cannot open a nil source" unless !@gen_source.nil?    
    
    begin
      File.open(@gen_source) do |f|
        while(line = f.readline)
          line.chomp
	  parts = line.gsub(/"/,'').split(',')

	  
  	  model = Allstartxt.new 
	  
	model.Property1 = parts[0]
	  
	model.Property2 = parts[1]
	  
	model.Property3 = parts[2]
	  
 	  @content << model
        end
      end 
    rescue Errno::ENOENT => e 
      puts "Unable to open source #{@gen_source}"
      return nil
    rescue EOFError 
    end

    @content
  end

  def find_by_Property1(val)
    @content.keep_if { |a| a.Property1 == val }
  end
 
  def find_by_Property2(val)
    @content.keep_if { |a| a.Property2.to_i == val }
  end
 
  def find_by_Property3(val)
    @content.keep_if { |a| a.Property3 == val }
  end
 
end
