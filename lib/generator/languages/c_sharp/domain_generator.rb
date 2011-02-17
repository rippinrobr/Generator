require_relative '../file_mgr'
require_relative '../../utils/array'
require_relative '../../utils/string.rb'
require_relative 'helpers'
require_relative 'string'
require_relative 'language_settings'

require 'etc'
require 'erb'

class DomainGenerator
  include FileMgr
  include CSharpHelpers

  def initialize(settings, domain_class_name = '')
    @settings = settings
    @settings.output_settings[:service_class_name] = "#{@settings.class_name}_Service"
  end

  def generate_code
    print "Creating a domain class for #{@settings.output_settings[:service_class_name]} with class name of #{@settings.output_settings[:service_class_name]}..." 
    @settings.output_settings[:imports] = [] if @settings.output_settings[:imports].nil?
    template = File.join(File.dirname(__FILE__), "templates/#{@settings.output_settings[:input_type]}_domain.erb") 
    b = binding
    engine = ERB.new( File.read(template), 0, '-%>')
    write_class_file(@settings.output_settings[:service_output_dir], @settings.output_settings[:service_class_name], engine.result(b), LanguageSettings::FILE_EXTENSION)
    puts "Done!"
  end
end
