#---------------------------------------------------------------------
# Generated on 2011-02-08 17:29:07 -0500 by rob
# Using Generator 0.1.1
#---------------------------------------------------------------------
require './allstar_with_headers_txt'

class AllstarWithHeadersTxtService
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

	  
  	  model = AllstarWithHeadersTxt.new 
	  
	model.lahman_id = parts[0]
	  
	model.year_id = parts[1]
	  
	model.lg_id = parts[2]
	  
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

  def find_by_lahman_id(val)
    @content.keep_if { |a| a.lahman_id == val }
  end
 
  def find_by_year_id(val)
    @content.keep_if { |a| a.year_id.to_i == val }
  end
 
  def find_by_lg_id(val)
    @content.keep_if { |a| a.lg_id == val }
  end
 
end
