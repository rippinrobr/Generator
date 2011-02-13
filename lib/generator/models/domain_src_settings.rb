class DomainSrcSettings
  attr_accessor :output_settings, :models, :class_name, :class_attributes, :properties

  def initialize(class_name, output_settings, properties)
    @output_settings = output_settings
    @class_name	     = class_name
    @properties      = properties
  end

  def get_table_columns(table_name)
    cols = []
    @columns.each { |t| cols.push t unless table_name != t.table_name 
      @db_tables.push t.table_name unless @db_tables.include? t.table_name }

    cols
  end

  def write_convert_method(data_type, index)
    return "Convert.ToInt32(data[#{index}])" unless data_type != "int"
    return "Convert.ToInt16(data[#{index}])" unless data_type != "smallint"
    return "Convert.ToDateTime(data[#{index}])" unless data_type != "datetime"
    return "data[#{index}]" unless data_type != "string"
  end
end
