require_relative 'step_helper'

Given /^the source "([^"]*)"$/ do |url|
  @args = ["-i", "url", "-url", url] 
end

When /^I have a model output dir of "([^"]*)"$/ do |mod|
  @mod_output_dir = "#{mod}"

  @args << "-mod"
  @args << mod
end

When /^I have a service output dir of "([^"]*)"$/ do |sod|
  @sod_output_dir = "#{sod}"
  @args << "-sod"
  @args << sod
end

When /^I run the generator to create a model and service class in the language "([^"]*)" with the name "([^"]*)"$/ do |language, service_class_name|
  @args << "-l"
  @args << language
  @args << "-sc"
  @args << service_class_name
  @args << "-mc"
  @args << @model_class_name
  cmd = Generator::CmdLine.new(output)

  cmd.run @args 
end

Then /^I have a model class file with the name "([^"]*)"$/ do |mod_class_name|
   @model_class_name = mod_class_name.slice(0...-3)
   puts File.join(@mod_output_dir, mod_class_name)
   File.exists?(File.join(@mod_output_dir, mod_class_name)).should == true
end

Then /^I should see a model class file with the name "([^"]*)"$/ do |mod_class_name|
   File.exists?(File.join(@mod_output_dir, mod_class_name)).should == true
end

Then /^a service class file with the name "([^"]*)"$/ do |sod_class_name|
  puts "output file => #{File.join(@sod_output_dir, sod_class_name)}"
  File.exists?(File.join(@sod_output_dir, sod_class_name)).should == true
end

