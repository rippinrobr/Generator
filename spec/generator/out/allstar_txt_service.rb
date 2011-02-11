#---------------------------------------------------------------------
# Generated on 2011-02-09 10:01:49 -0500 by rob
# Using Generator 0.1.1
#---------------------------------------------------------------------
require './allstar_txt'

class AllstarTxtService
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

	  
  	  model = AllstarTxt.new 
	  
	model.attr_1 = parts[0]
	  
	model.attr_2 = parts[1]
	  
	model.attr_3 = parts[2]
	  
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

  def find_by_attr_1(val)
    @content.keep_if { |a| a.attr_1 == val }
  end
 
  def find_by_attr_2(val)
    @content.keep_if { |a| a.attr_2.to_i == val }
  end
 
  def find_by_attr_3(val)
    @content.keep_if { |a| a.attr_3 == val }
  end
 
end
