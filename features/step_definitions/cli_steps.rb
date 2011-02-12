require File.join(File.dirname(__FILE__), 'step_helper.rb')

Given /^I have not started the script$/ do
  output.messages.clear
end

When /^I start a generation job$/ do
  cmd = Generator::CmdLine.new(output)
end

Then /^I should see "([^"]*)"$/ do |message|
  output.messages.should include(message)
end

When /^I start a generation job with "([^"]*)" "([^"]*)" and no "([^"]*)" "([^"]*)"$/ do |cmd1, val1, cmd2, val2|
  args = [cmd1, val1, cmd2, val2] 
  cmd = Generator::CmdLine.new(output)
  cmd.run args
end

When /^I start a generation job with "([^"]*)" "([^"]*)" and no "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)"$/ do |cmd1, val1, cmd2, val2, cmd3, val3|
  args = [cmd1, val1, cmd2, val2, cmd3, File.join( File.dirname(__FILE__) , val3 )] 
  cmd = Generator::CmdLine.new(output)
  cmd.run args
end

When /^I start a generation job with "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)"$/ do |cmd1, val1, cmd2, val2, cmd3, val3|
  args = [cmd1, val1, cmd2, val2, cmd3, val3]
  cmd = Generator::CmdLine.new(output)
  cmd.run args
end

When /^I start a generation job with "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)"$/ do |cmd1, val1, cmd2, val2, cmd3, val3, cmd4, val4|
  args = [cmd1, val1, cmd2, val2, cmd3, val3, cmd4, val4] 
  cmd = Generator::CmdLine.new(output)
  cmd.run args
end

When /^I start a generation job with "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)"$/ do |cmd1, val1, cmd2, val2, cmd3|
  args = [cmd1, val1, cmd2, val2, cmd3] 
  cmd = Generator::CmdLine.new(output)
  cmd.run args
end

Then /^I should see no output$/ do
  output.messages.length.should == 0 
end

When /^I pass the command "([^"]*)"$/ do |cmd|
  cmd_line = Generator::CmdLine.new(output)
  cmd_line.run([cmd])
end

When /^I start a generation job with "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)"$/ do |cmd1, val1, cmd2, val2, cmd3, val3, cmd_4|
  cmd = Generator::CmdLine.new(output)
  cmd.run [cmd1, val1, cmd2, val2, cmd3, val3, cmd_4]
end
