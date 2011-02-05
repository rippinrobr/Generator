require 'PresentationFramework'
require 'PresentationCore'
require File.join(File.dirname(__FILE__), 'base_view_model')
require File.join(File.dirname(__FILE__), '../../lib/models/load_form_parameters')

include System::Windows
include System::Windows::Controls

class SettingsViewModel < BaseViewModel
  attr_accessor :source, :languages, :model_type, :create_domain_src
   
  def initialize(win)
    super(win)
    @source          = nil
    @submit_handlers = []
  end

  def add_submit_handler(&block)
    @submit_handlers.push block
  end

  def load_form
    dbRb.Checked do 
      textSourcePathStackPanel.Visibility = Visibility.Collapsed 
      @source = :db
    end

    textRb.Checked do 
      textSourcePathStackPanel.Visibility = Visibility.Visible 
      @source = :text
    end

    cSharpRB.Checked do 
      @language = :c_sharp
      emitRB.IsEnabled = true
      emitRB.IsChecked = true
    end

    rubyRB.Checked do 
      @language = :ruby
      emitRB.IsEnabled = false
      srcRB.IsChecked = true
    end

    emitRB.Checked do
      @model_type = :emit
    end

    srcRB.Checked do
      @model_type = :src
    end

    saveSettingsBtn.click.add method(:save_settings)
  end

  private
  def process_text_source
    srcFilePath = textFilePathTxtBox.Text
    if !srcFilePath.nil? && srcFilePath.to_s != ''
      if File.exists?(srcFilePath)
        @class_def = ReadRawInput.new :text, 
	    textFilePathTxtBox.Text, 
	    @language,
            hasHeaderCheckBox.IsChecked
        @class_def = @class_def.read
      else
        show_warning_box "The file #{srcFilePath} does not exist."
        set_focus_on_file_path
	return false
      end
    else
      show_warning_box.show "A path is required with the text source."
      set_focus_on_file_path
      return false
    end
    true
  end

  def save_settings(s,e)
    if @source.nil?
      show_warning_box "Please choose a source."
      return
    end

    if @language.nil?
      show_warning_box "Please choose a language."
      return
    end

    @create_domain_src = generateDomainCB.IsChecked

    # check to see if text was checked and make sure
    # and if so ensure there's a path in the text field
    @class_def = nil
    if @source == :text
      if textFilePathTxtBox.Text.nil? || textFilePathTxtBox.Text.to_s == ''
	show_warning_box "Text sources require a file.  Please enter a file."
        set_focus_on_file_path
	return
      end
      all_good = process_text_source
    else
      if @source == :db
        all_good = true
      end
    end
  
    params = LoadFormParameters.new @source, @model_type, @class_def, @create_domain_src, @language, textFilePathTxtBox.Text
    params.has_header = hasHeaderCheckBox.IsChecked
    @submit_handlers.each { |h| h.call(params) } unless !all_good
  end

  def set_focus_on_file_path
    textFilePathTxtBox.SelectAll
    textFilePathTxtBox.Focus
  end
end
