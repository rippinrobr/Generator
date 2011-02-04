require 'spec_helper'

module Generator
  describe CmdLine do
    def check_output(output)
      output.should_receive(:puts).with('Required Options:')
      output.should_receive(:puts).with('--input-type, -i  db|text')
      output.should_receive(:puts).with('	when using text --source-file or -sf followed by a path to the input file is required')
      output.should_receive(:puts).with('--language, -l    ruby|c_sharp')
      output.should_receive(:puts).with('')
      output.should_receive(:puts).with('Optional:')
      output.should_receive(:puts).with('--assembly, -a  name of the output assembly (.NET only)')
      output.should_receive(:puts).with('--service-output-dir, -sod  the name of the directory to place the service source')
      output.should_receive(:puts).with('--help, -h  displays this message')
      output.should_receive(:puts).with('--imports, -i   the name of the libraries to include in the generated source')
      output.should_receive(:puts).with('--model, -m  src | emit (.NET only) - indicates how you want the model code created')
      output.should_receive(:puts).with('--model-output-dir, -mod  the name of the directory to place the model source/dll')
      output.should_receive(:puts).with('--quite, -q  runs the script without writing output')
    end
 
    def should_not_have_output(output)
      output.should_not_receive(:puts).with('Required Options:')
      output.should_not_receive(:puts).with('--input-type, -i  db|text')
      output.should_not_receive(:puts).with('	when using text --source-file or -sf followed by a path to the input file is required')
      output.should_not_receive(:puts).with('--language, -l    ruby|c_sharp')
      output.should_not_receive(:puts).with('')
      output.should_not_receive(:puts).with('Optional:')
      output.should_not_receive(:puts).with('--assembly, -a  name of the output assembly (.NET only)')
      output.should_not_receive(:puts).with('--service-output-dir, -sod  the name of the directory to place the service source')
      output.should_not_receive(:puts).with('--help, -h  displays this message')
      output.should_not_receive(:puts).with('--imports, -i   the name of the libraries to include in the generated source')
      output.should_not_receive(:puts).with('--model, -m  src | emit (.NET only) - indicates how you want the model code created')
      output.should_not_receive(:puts).with('--model-output-dir, -mod  the name of the directory to place the model source/dll')
      output.should_not_receive(:puts).with('--quite, -q  runs the script without writing output')
    end

   let(:output) { double('output').as_null_object}
   let(:cmd_line) { CmdLine.new(output) }

   describe "Generate Ruby Code" do
      it "should display error message when text is selected as input type but no source file is provided" do
        output.should_receive(:puts).with('A path to a source file is required')
        check_output(output)

        args = ["-m", "src", "-l", "ruby", "-i", "text", "--model-output-dir", "./out/allstar_txt.rb", "--service-output-dir", "./out/allstar_txt_service.rb" ]
	cmd_line.run args
      end

      it "should create a model class when all the necessary command line options are provided" do
        should_not_have_output(output)
    
        args = ["-m", "src", "-l", "ruby", "-i", "text", "--model-output-dir", "../spec/generator/out", "--service-output-dir", "../spec/generator/out", "-sf", File.join(File.dirname(__FILE__), "data/allstar.txt") ]
	cmd_line.run args
        File.exists?(File.join(File.dirname(__FILE__), "out/allstar_txt.rb")).should == true
      end

      it "should create a service class when all the necessary command_line options are provided" do
        should_not_have_output(output)
    
        args = ["-m", "src", "-l", "ruby", "-i", "text", "--model-output-dir", "../spec/generator/out", "--service-output-dir", "../spec/generator/out", "-sf", File.join(File.dirname(__FILE__), "data/allstar.txt") ]
	cmd_line.run args
        File.exists?(File.join(File.dirname(__FILE__), "out/allstar_txt_service.rb")).should == true
      end
    end
  end
end
 
