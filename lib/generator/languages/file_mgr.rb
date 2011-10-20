require "generator/utils/string"
require "generator/utils/os"

module FileMgr
  def set_output_file_path(output_dir, class_name, file_ext)
    file_path = output_dir
    file_path = "" unless !file_path.nil?
    file_name = "#{class_name.clean_name}.#{file_ext}"

    file_seperator = "/" 
    file_seperator = "\\" if OS::windows?
 
    if !file_path.ends_with? file_seperator
      file_path += file_seperator
    end
    file_path += file_name
    file_path
  end
  
  def write_class_file(output_dir, class_name, class_text, file_ext='cs')
    File.open(set_output_file_path(output_dir, class_name, file_ext), "w") do |f|
      f.puts class_text
    end
  end

  def get_template(template_file)
    File.read(template_file)
  end
end
