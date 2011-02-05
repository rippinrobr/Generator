require 'PresentationFramework'
require 'PresentationCore'

class WindowsManager
  include System::Windows
  attr_accessor :controller, :view

  def initialize(controller)
    @controller = controller
  end

  def show_window
    app = System::Windows::Application.new
    app.startup.add method(:display_window)
    app.run
  end

private
  def display_window(sender, args)
    @controller.show_window
  end
end
