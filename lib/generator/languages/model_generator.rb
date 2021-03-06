require 'etc'
require 'erb'
require 'generator/languages/file_mgr'

class ModelGenerator
  include FileMgr

  def initialize
  end

  def generate(model_class_def, settings)
     language = settings[:language]
     load File.join(File.dirname(__FILE__), "#{language}/language_settings.rb")

     @model_class_def = model_class_def
     settings[:model_name] = model_class_def.name
     @settings = settings

     template = File.join(File.dirname(__FILE__), "./#{language}/templates/model.erb")
     input_specific_model_template_path = File.join(File.dirname(__FILE__), "./#{language}/templates/#{@settings[:input_type]}_model.erb") 
     template = input_specific_model_template_path if File.exists?(input_specific_model_template_path)

     b = binding

     engine = ERB.new( File.read(template), 0, "-%>")
     write_class_file(settings[:model_output_dir], @model_class_def.name, 
		      engine.result(b), LanguageSettings::FILE_EXTENSION)

     [@model_class_def, @model_class_def.name.gsub(/(M|m)odel/,'').clean_name]
  end
end
