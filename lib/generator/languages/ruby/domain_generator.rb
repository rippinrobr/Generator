require_relative '../../utils/string'
require_relative '../file_mgr'
require_relative 'string'
require_relative 'helpers'
require_relative 'language_settings'
require 'etc'
require 'erb'

class DomainGenerator
  include FileMgr
  include Helpers
  include LanguageSettings

  def initialize(settings, domain_class_name = '')
    @settings = settings
    @domain_class_name = "#{@settings.class_name.singularize().clean_name}_service"
  end

  def generate_code
    print "Creating a domain class for #{@settings.class_name.clean_name} with class name of #{@domain_class_name.clean_name}..." 
    template = File.join(File.dirname(__FILE__), "templates/#{@settings.output_settings[:input_type]}_domain.erb") 
    b = binding
    engine = ERB.new( File.read(template), 0, '-%>')
    write_class_file(@settings.output_settings[:service_output_dir], 
		     @domain_class_name, 
		     engine.result(b), 
		     LanguageSettings::FILE_EXTENSION)
    puts "Done!"
  end
end
