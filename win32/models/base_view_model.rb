
require 'PresentationFramework'
require 'PresentationCore'
class BaseViewModel
  def initialize(win)
    @window = win
  end

  def method_missing(name)
    super if @window.nil?
    control = @window.find_name(name)
    if control.nil? then super else control end
  end

  def add_click_handler(obj, &block) 
     obj.click.add block
  end

  def show_warning_box(message_text)
     MessageBox.Show message_text, 
	     "IronRuby DAL Code Generator", 
	     MessageBoxButton.OK,
	     MessageBoxImage.Warning
  end
end
