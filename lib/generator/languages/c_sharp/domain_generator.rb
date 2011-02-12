require_relative '../file_mgr'
require_relative '../../utils/array'
require_relative '../../utils/string.rb'
require_relative 'helpers'
require_relative 'string'
require_relative 'db_helpers'
require_relative 'language_settings'
require 'etc'
require 'erb'

class DomainGenerator
  include FileMgr
  include DbHelpers
  include CSharpHelpers

  def initialize(settings, domain_class_name = '')
    @settings = settings
    @settings.output_settings[:service_class_name] = "#{@settings.class_name}Service"

    set_data_types @settings.columns 
    set_key_data_types(@settings.table_keys)
  end

  def generate_code
    print "Creating a domain class for #{@settings.output_settings[:service_class_name]} with class name of #{@settings.output_settings[:service_class_name]}..." 
    template = File.join(File.dirname(__FILE__), "templates/#{@settings.output_settings[:input_type]}_domain.erb") 
    b = binding
    engine = ERB.new( File.read(template), 0, '-%>')
    write_class_file(@settings.output_settings[:service_output_dir], @settings.output_settings[:service_class_name], engine.result(b), LanguageSettings::FILE_EXTENSION)
    puts "Done!"
  end

  private
  def set_data_types(cols_to_fix)
    cols_to_fix.each do |g|
      if g.respond_to?('field_type')
   	g.field_type = get_type_as_string(g.field_type.to_s, g.elements_to_views.first.required)
      end
    end
  end

  def set_key_data_types table_keys
    table_keys.each do |k|
      k[1][0][0] = get_type_as_string(k[1][0][0].to_s, true)
    end
  end
end
