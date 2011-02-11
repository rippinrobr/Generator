require File.join(File.dirname(__FILE__), 'step_helper.rb')

Given /^the source "([^"]*)"$/ do |url|
  @args = ["-i", "url", "-url", url] 
end

When /^I have a model output dir of "([^"]*)"$/ do |mod|
  @mod_output_dir = "#{mod}"

  @args << "-mod"
  @args << mod
end

When /^I have a service output dir of "([^"]*)"$/ do |sod|
  @args << "-sod"
  @args << sod
end

When /^I run the generator to create a model and service class in the language "([^"]*)"$/ do |language|
  @args << "-l"
  @args << language

  cmd = Generator::CmdLine.new(output)
  cmd.run @args 
end

Then /^I should see a model class file with the name "([^"]*)"$/ do |mod_class_name|
   File.exists?(File.join(@mod_output_dir, mod_class_name)).should == true
end

Then /^a service class file with the name "([^"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

