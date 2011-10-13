require 'generator/utils/string'
require 'generator/languages/file_mgr'
require 'generator/languages/ruby/string'
require 'generator/languages/ruby/helpers'
require 'generator/languages/ruby/language_settings'
require 'etc'
require 'erb'

class MigrationGenerator
  include FileMgr
  include Helpers
  include LanguageSettings

  def initialize(options, columns)
    @options = options
    @columns = columns
  end

  def clean_db_data_types(db_type)
    if db_type == "int"
      "integer"
    else
      db_type
    end
  end

  def generate_code
    template = File.join(File.dirname(__FILE__),
                         "templates/migration.erb")
    b = binding
    engine = ERB.new(File.read(template), 0, '-%>')
    write_class_file(@options[:migration_output_dir], 
                     @options[:migration_file_name],
                     engine.result(b),
                     "rb")
  end
end
