# Check into removing the class totally.  I believe this is here to force the non-db sources to
# act like the db source.  This isn't necessary.  I am moving towards having code_gen do its own
# thing for each input.  Then work on the generation part being as similar as possible across all
# sources
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

