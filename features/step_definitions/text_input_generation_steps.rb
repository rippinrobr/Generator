require File.join(File.dirname(__FILE__), 'step_helper.rb')
@args = []
@model_out_dir   = ''
@service_out_dir = ''
Given /^I've selected "([^"]*)" as my output language$/ do |language|
  @args = ["-l",language]
end

Given /^my input type is "([^"]*)"$/ do |input_type|
  @args << "-i"
  @args << input_type
end

Given /^my source file is "([^"]*)"$/ do |source_file|
 @args << "-sf"
 @args << File.join(File.dirname(__FILE__), source_file)
end

Given /^I will indicate if the file has a header here "([^"]*)"$/ do |has_header|
  @args << "--header" if has_header == "true"
end

Given /^I select "([^"]*)" as my output for the models$/ do |model|
  @args << "-m"
  @args << model 
end

Given /^I pass the model output directory here "([^"]*)"$/ do |model_output|
  @model_out_dir =  model_output
  @args << "-mod"
  @args << model_output
end

Given /^I pass the service output directory here "([^"]*)"$/ do |service_output|
  if !service_output.nil? && service_output != ''
    @service_out_dir = service_output
    @args << "-sod"
    @args << service_output
  end
end

When /^I run the script$/ do
  cmd = Generator::CmdLine.new(output)
  cmd.run @args
end

Then /^I should see the the model file here "([^"]*)"$/ do |model_file|
  File.exists?(File.join(File.join(File.dirname(__FILE__), "../" + @model_out_dir), model_file)).should == true
end

Then /^I should see the the service file here "([^"]*)"$/ do |service_file|
  if !service_file.nil? && service_file != ''
    File.exists?(File.join(File.join(File.dirname(__FILE__), "../" + @service_out_dir), service_file)).should == true
  end
end
