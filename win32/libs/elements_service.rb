require 'mscorlib'
require File.join(File.dirname(__FILE__), 'IRCDemo.Data')
require 'System.Core'
using_clr_extensions System::Linq

class ElementsService
@@CONSTR = 'metadata=res://*/ElementsDb.csdl|res://*/ElementsDb.ssdl|res://*/ElementsDb.msl;provider=System.Data.SqlClient;provider connection string="Data Source=.\SqlExpress;Initial Catalog=IronRubyDemo;Integrated Security=True;MultipleActiveResultSets=True";'

  def initialize
    @svc = IRCDemo::Data::ElementsService.new(@@CONSTR)
  end

  def element
    @svc.Element
  end

  def elements_to_views
    @svc.ElementsToViews
  end

  def player
    @svc.Player
  end

  def view
    @svc.View
  end

  def get_properties(type)
    props = []
    type.get_properties.each do |p|
       if (p.to_s =~ /^System.Data.*$/).nil? && (p.to_s =~ /^IRCDemo.Data.*$/).nil?
	 props.push( p.to_s.split(' ') )
       end
    end
    props
  end

  def get_columns(table_name)
    props = []
    get_elements.where( lambda{ |t| t.table_name == table_name}).each do |c|
      props.push( [c.field_name.c_sharpify, c.col_name] )
    end

    props
  end

  def get_nullable_return_type(type)
    @svc.GetNullableReturnType(type)
  end

  def get_elements
    @svc.GetElements
  end

  def get_keys(table_name)
    keys = []
    get_elements.where( lambda{ |t| t.table_name == table_name }).each do |c|
      c.elements_to_views.where( lambda { |tc| tc.is_key == true }).each do |f|
	keys.push c.col_name
      end
    end

    keys
  end

  def get_views
    # The where method here is from System.Linq
    @svc.GetElementViews.where( lambda{ |w|  w.end_date.nil? })
  end

  def get_elements_in_view(view_id)
    @svc.GetElementsInView(view_id)
  end

  def get_elements_to_views()
    @svc.GetElementsToViews
  end

  def dispose
    @svc.dispose
  end
end
