module Helpers
  def data_type_conversion(data_type)
    if data_type.nil? || data_type == ""
      data_type = "string"
    end

    puts "data_type: #{data_type}"
    if data_type.downcase == "int"
      ".to_i"
    elsif data_type.downcase == "float"
      ".to_f"
    else
      ""
    end
  end
end
