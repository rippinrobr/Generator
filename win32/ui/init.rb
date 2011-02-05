require 'PresentationFramework'
require 'PresentationCore'
require File.dirname(__FILE__) + '/../../lib/parsers/read_raw_input'
require File.dirname(__FILE__) + '/main_win'
require File.dirname(__FILE__) + '/controllers/application_controller' 

cec = ApplicationController.new 'win32/ui/views/class_viewer.xaml'
@win = WindowsManager.new cec
@win.show_window
