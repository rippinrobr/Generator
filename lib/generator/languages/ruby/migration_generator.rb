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

  def generate_migration
    process_template("templates/migration.erb",
                     @options[:migration_output_dir],
                     @options[:migration_file_name])
  end

  def generate_ar_model
    @options[:db_table_names].map do |dtn_and_cols| 
      process_ar_template("templates/ar_model.erb", 
                     @options[:migration_model_dir],
                     "#{dtn_and_cols[0]}_source")
    end
  end

  def generate_ar_connection
    process_template( "templates/ar_connection.erb", 
                      @options[:migration_output_dir],
                      "ar_connection")
  end
  
  def generate_load_script
    process_template("templates/datasource_loader.erb",
                     @options[:migration_output_dir],
                     "datasource_loader")
  end

private
  def process_template(template_path, output_dir, file_name)
    template = File.join(File.dirname(__FILE__),
                         template_path)
    b = binding
    engine = ERB.new(File.read(template), 0, '-%>')
    write_class_file(output_dir, file_name, engine.result(b), "rb")
  end

  def process_ar_template(template_path, output_dir, file_name)
    @ar_class_name = file_name.camelize
    template = File.join(File.dirname(__FILE__),
                         template_path)
    b = binding
    engine = ERB.new(File.read(template), 0, '-%>')
    write_class_file(output_dir, file_name, engine.result(b), "rb")
  end
end
