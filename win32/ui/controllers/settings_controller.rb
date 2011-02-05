require 'PresentationFramework'
require 'PresentationCore'

include System::Windows
include System::Windows::Controls

class SettingsController < BaseController
  def initialize view_path
    super(view_path)

    source.Checked  {
      MessageBox.Show "Checked!"
    }    
  end

  private
  def init_form
  end

end
