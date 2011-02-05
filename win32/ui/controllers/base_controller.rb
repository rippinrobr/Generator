require 'PresentationFramework'
require 'PresentationCore'
include System::Windows
include System::Windows::Controls

class BaseController
  def initialize view_path
    print "Reading XAML file..."
    xaml = File.open(view_path,"r").read
    puts "Done!"

    print "Parsing XAML..."
    @window = Markup::XamlReader.parse(xaml)
    puts "Done!"
  end

  def show_window 
    @window.show
  end

  def method_missing(name)
    super if @window.nil?
    control = @window.find_name(name)
    if control.nil? then super else control end
  end
end
