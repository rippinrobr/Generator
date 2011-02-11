#---------------------------------------------------------------------
# Generated on 2011-02-08 18:03:46 -0500 by rob
# Using Generator 0.1.1
#---------------------------------------------------------------------
require './Allstarwithheaderstxt'

class AllstarwithheaderstxtService
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

	  
  	  model = Allstarwithheaderstxt.new 
	  
	model.Lahmanid = parts[0]
	  
	model.Yearid = parts[1]
	  
	model.Lgid = parts[2]
	  
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

  def find_by_Lahmanid(val)
    @content.keep_if { |a| a.Lahmanid == val }
  end
 
  def find_by_Yearid(val)
    @content.keep_if { |a| a.Yearid.to_i == val }
  end
 
  def find_by_Lgid(val)
    @content.keep_if { |a| a.Lgid == val }
  end
 
end
