class DummyClass2
  def required
    true
  end
end

class DummyClass
    def first
      DummyClass2.new
    end
end

class Prop
  attr_accessor :table_name, :field_name, :field_type, :col_name

  def initialize(table_name, field_name, field_type)
    @table_name = table_name
    @field_name = field_name
    @col_name   = field_name
    @field_type = field_type
  end

  def elements_to_views
    DummyClass.new
  end
end

