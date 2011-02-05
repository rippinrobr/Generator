require File.dirname(__FILE__) + '/../../../lib/code_gen'
require File.dirname(__FILE__) + '/../../../lib/text_elements_service'
require File.join(File.dirname(__FILE__), 'base_controller')
Dir[File.dirname(__FILE__) + '/../../models/*.rb'].each { |file| require file.gsub(/\.rb/,'') }

class ApplicationController < BaseController
  def initialize view_path
    super(view_path)

    @vm             = RecordClass.new
    @settings_vm    = SettingsViewModel.new @window
    @class_def_vm   = ModelClassDefinitionViewModel.new @window
    @outputs_vm     = OutputViewModel.new @window
    @model_def      = ModelClassDefinition.new
    @tabs_to_source = Hash.new
    
    @tabs_to_source[:text] = defineClassTab
    @tabs_to_source[:db]   = outputSettingsTab

    init_app
  end

  private

  def init_app
    @settings_vm.load_form

    @settings_vm.add_submit_handler do  |params|
      @outputs_vm.load_form(params) unless params.source == :text
      @class_def_vm.load_form(params) unless params.class_def.nil?
      @tabs_to_source[params.source].IsSelected = true
    end

    @class_def_vm.add_submit_handler do |params|
      @outputs_vm.load_form(params) 
      outputSettingsTab.IsSelected = true
    end
  end
end
