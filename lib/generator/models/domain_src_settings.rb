class DomainSrcSettings
  attr_accessor :output_settings, :models, :class_name, :class_attributes, :columns, :db_tables, :table_keys

  def initialize(class_name, output_settings, columns, keys=[])\
    @output_settings = output_settings
    @class_name	     = class_name
    @columns	     = columns
    @db_tables       = []
    @table_keys      = Hash.new

    @columns.each do |t| 

      if t.respond_to? 'table_name'
        @db_tables.push t.table_name unless @db_tables.include? t.table_name
        if t.elements_to_views.respond_to? 'First'
        # the db input would be here
          if t.elements_to_views.First.is_key
	    @table_keys[t.table_name] = [] unless @table_keys.keys.include? t.table_name
	    @table_keys[t.table_name].push [t.field_type, t.field_name, t.col_name]
          end
        else
          #text input
        end
      end
    end 
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
