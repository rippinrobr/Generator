 
module CSharpHelpers
  def get_type(field_type, is_required)
    # These are for .NET code generation
    case 
    when field_type.eql?('string')
      return System::String.new(" ").GetType
    when field_type.eql?('smallint')
      return System::Int16.to_clr_type
    when field_type.eql?('int') || field_type.downcase.eql?('int32')
      if is_required
        return 1.GetType
      else
	return CodeGeneration::Helpers::CodeGenHelpers.GetNullableReturnType('Int') 
      end
    when field_type.eql?('bool') || field_type.eql?('bit') || field_type.eql?('Boolean')
      return true.GetType
    when field_type.eql?('bigint')
      return System::Int64.to_clr_type
    when field_type.eql?('datetime') || field_type.eql?('DateTime')
      if is_required
        return System::DateTime.new().GetType
      else
	return CodeGeneration::Helpers::CodeGenHelpers.GetNullableReturnType('DateTime')
      end
    when field_type =~ /decimal\(\d,\d\)/
      if is_required
        return System::Decimal.new(0.300).GetType,
      else
	return CodeGeneration::Helpers::CodeGenHelpers.GetNullableReturnType('Decimal')
      end
    else
      return System::String.new(" ").GetType
    end
  end

  def get_type_as_string(field_type, is_required)
    case 
    when field_type.upcase.eql?('SMALLINT')
      return "short"
    when field_type.upcase.eql?('INT') || field_type.upcase.eql?('INT32') 
      return "int#{is_required == true ? '' : '?'}"
    when field_type.upcase.eql?('BOOL') || field_type.eql?('BIT')
      return "bool"
    when field_type.upcase.eql?('BIGINT')
      return "long"
    when field_type.upcase.eql?('DATETIME')
      return "DateTime#{is_required == true ? '' : '?'}"
    when field_type =~ /decimal\(\d,\d\)/i
      return "Decimal#{is_required == true ? '' : '?'}"
    else
      return field_type
    end
  end
 end
