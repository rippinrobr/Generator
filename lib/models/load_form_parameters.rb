class LoadFormParameters
  attr_accessor :source, :model_type, :create_domain_source, :class_def, :language, :input_file, :has_header

  def initialize(source, model_type, class_def, create_domain_source, language, input_file=nil)
    @source 		  = source
    @model_type 	  = model_type
    @class_def            = class_def
    @create_domain_source = create_domain_source
    @language		  = language
    @input_file		  = input_file
  end

  def to_s
    "*** LoadFormParameters\nsource: #{@source}\nmodel_type: #{@model_type}\nclass_def: #{@class_def}\ncreate_domain_source: #{@create_domain_source}\nlanguage: #{@language}\ninput_file: #{@input_file}\n***\n"
  end
end
