module DbHelpers  
  def method_definition_key_params
	key_params = ""
	i = 0
	@settings.table_keys.each do |k| 
	  if i > 0 
	    key_params = "#{key_params}, #{k[1][0][0]} #{k[1][0][1].downcase.gsub(/ /,'_')}"
	  else
	    key_params  ="#{k[1][0][0]} #{k[1][0][1].downcase.gsub(/ /,'_')}"
	  end
	  i += 1; 
	end

	key_params
  end

  def where_clause_for_all_tables
    i = 0
    where_clause = ""
    @settings.table_keys.each do |k| 
      if i > 0 
	where_clause = "#{where_clause} && w.#{k[1][0][1].clean_name.camelize} == #{k[1][0][1].downcase.gsub(/ /,'_')}"
      else
	where_clause = "w => w.#{k[1][0][1].clean_name.camelize} == #{k[1][0][1].downcase.gsub(/ /,'_')}"
      end
      i += 1 
     end

     where_clause
  end

  def create_call_parameters(table)
    params = ''
    col_names = []
    i = 0

    @settings.get_table_columns(table).each { |c| col_names.push(c.col_name) } 

    @settings.table_keys.each do |k| 
      if col_names.include?(k[1][0][2])
	if i > 0 
	  params = "#{params}," 
	end
        params = "#{params} #{k[1][0][1].downcase.gsub(/ /,'_')}"
        i += 1
      end
    end
    params
  end

  def create_method_parameters(table)
    params = ''
    col_names = []
    i = 0

    @settings.get_table_columns(table).each { |c| col_names.push(c.col_name) } 
    @settings.table_keys.each do |k|
      if col_names.include?(k[1][0][2]) 
	if i > 0 
	  params = "#{params}," 
	end
	params = "#{params} #{k[1][0][0]} #{k[1][0][1].downcase.gsub(/ /,'_')}"
	i += 1
      end
    end
    params
  end

  def create_where_key_parameters(tables)
    params = ''
    col_names = []
    i = 0
    keys = []

    @tables.each do |table|
      @settings.get_table_columns(table).each do |c| 
	 col_names.push(c.col_name)
      end
    end 
    params
  end

  def create_where_parameters(table, ident)
    params = ''
    col_names = []
    i = 0

    @settings.get_table_columns(table).each { |c| col_names.push(c.col_name) } 
    @settings.table_keys.each do |k| 
      if col_names.include?(k[1][0][2])
	if i > 0 
	  params = "#{params} &&"
	end
	params = "#{params} #{ident}.#{k[1][0][2]} == #{k[1][0][1].downcase.gsub(/ /,'_')}"
	i += 1
      end
    end
    params
  end

  def singularize_db_entities(name)
    if !name.ends_with?("us")
      name.singularize.clean_name 
    else
      name.clean_name 
    end
  end
end
