require 'spec_helper'

def check_for_print_usage(output)
  output.should_receive(:puts).with('Required Options:')
  output.should_receive(:puts).with('--input-type, -i  url|text')
  output.should_receive(:puts).with('	when using url -url followed by a valid URI to the input is required')
  output.should_receive(:puts).with('	when using text --source-file or -sf followed by a path to the input file is required')
  output.should_receive(:puts).with('--language, -l    ruby|c_sharp')
  output.should_receive(:puts).with('')
  output.should_receive(:puts).with('Optional:')
  output.should_receive(:puts).with('--service-output-dir, -sod  the name of the directory to place the service source')
  output.should_receive(:puts).with('--help, -h  displays this message')
  output.should_receive(:puts).with('--imports, -i   the name of the libraries to include in the generated source')
  output.should_receive(:puts).with('--model, -m  src | emit (.NET only) - indicates how you want the model code created')
  output.should_receive(:puts).with('--model-output-dir, -mod  the name of the directory to place the model source/dll')
  output.should_receive(:puts).with('--quite, -q  runs the script without writing output')
end

module Generator
  describe CmdLine do
    let(:output) { double('output').as_null_object}
    let(:cmd_line) { CmdLine.new(output) }

    describe "missing/invalid required parameters" do
       it "should display help" do 
  	 check_for_print_usage(output)
         cmd_line.run
       end

       it "with 1 required field missing should display help" do
         check_for_print_usage(output)
         args = [ "--input-type", "text" ]
	 cmd_line.run args
       end

       it "with 1 required field (--input-type ) and 1 non-required should display help" do
         args = [ "--input-type","tex", "--face", "lift" ]
  	 output.should_receive(:puts).with("'tex' is not a supported input type")
  	 output.should_receive(:puts).with("Supported Input Types: url, text") 
	 cmd_line.run args
       end

       it "with 1 required field (-i) and 1 non-required should display help" do
         check_for_print_usage(output)
         args = [ "--i","text", "--face", "lift" ]
	 cmd_line.run args
       end

       it "with 1 required field (--language ) and 1 non-required should display help" do
         args = [ "--language","c_sharp", "--face", "lift" ]
  	 check_for_print_usage(output)
	 cmd_line.run args
       end

       it "with 1 required field (-l) and 1 non-required should display help" do
         check_for_print_usage(output)
         args = [ "--l","text", "--face", "lift" ]
	 cmd_line.run args
       end

       it "with both required options but with a non-supported language (ada)" do
  	 output.should_receive(:puts).with("'ada' is not a supported language")
  	 output.should_receive(:puts).with("Supported Languages: ruby, c_sharp") 

         args = [ "--language","ada", "--input-type", "text" ]
	 cmd_line.run args
       end

       it "with both required options but with a non-supported language (C++)" do
  	 output.should_receive(:puts).with("'C++' is not a supported language")
  	 output.should_receive(:puts).with("Supported Languages: ruby, c_sharp") 

         args = [ "-l","C++", "--input-type", "text" ]
	 cmd_line.run args
       end

       it "with both required options but with a non-supported input type (--input-type zip)" do
  	 output.should_receive(:puts).with("'zip' is not a supported input type")
  	 output.should_receive(:puts).with("Supported Input Types: url, text") 

         args = [ "--language","ruby", "--input-type", "zip" ]
	 cmd_line.run args
       end

       it "with both required options but with a non-supported input_source (-i zip)" do
  	 output.should_receive(:puts).with("'zip' is not a supported input type")
  	 output.should_receive(:puts).with("Supported Input Types: url, text") 

         args = [ "-i", "zip",  "--language","c_sharp"]
	 cmd_line.run args
       end
    end

    describe "Missing/Invalid Optional Parameter values" do
      it "should return the model's valid values when invalid value is passed in (-m)" do
        output.should_receive(:puts).with("'ears' is not a supported output option")
        output.should_receive(:puts).with("Supported Output Options: emit, src (default)")

        args = [ "-i", "text",  "--language","c_sharp", "-m", "ears", "-sf", File.join(File.dirname(__FILE__),"data/allstar.txt")]
	cmd_line.run args
      end

      it "should return the model's valid values when invalid value is passed in (--model )" do
        output.should_receive(:puts).with("'ears' is not a supported output option")
        output.should_receive(:puts).with("Supported Output Options: emit, src (default)")

        args = [ "-i", "text",  "--language","c_sharp", "--model", "ears", "-sf", File.join(File.dirname(__FILE__),"data/allstar.txt")]
	cmd_line.run args
      end

      it "should return the model namespace/module requirements message (-mn)" do
        output.should_receive(:puts).with("-mn | --model-namespace requires a name")

        args = [ "-i", "text",  "--language","c_sharp", "-mn", "", "-sf", File.join(File.dirname(__FILE__),"data/allstar.txt")]
	cmd_line.run args
      end

      it "should return the service namespace/module requirements message (--model-namespace)" do
        output.should_receive(:puts).with("-mn | --model-namespace requires a name")
        args = [ "-i", "text",  "--language","c_sharp", "--model-namespace", "", "-sf", File.join(File.dirname(__FILE__),"data/allstar.txt")]

	cmd_line.run args
      end

      it "should return the message that says the model output dir must be a valid directory (-mod)"  do
        output.should_receive(:puts).with("-mod | --model-output-dir requires a valid directory")
        args = [ "-i", "text",  "--language","c_sharp", "-mod", "", "-sf", File.join(File.dirname(__FILE__),"data/allstar.txt")]
        
	cmd_line.run args
      end

      it "should return the message that says the model output dir must be a valid directory (--model-output-dir)" do
        output.should_receive(:puts).with("-mod | --model-output-dir requires a valid directory")

        args = [ "-i", "text",  "--language","c_sharp", "--model-output-dir", "", "-sf", File.join(File.dirname(__FILE__),"data/allstar.txt")]
	cmd_line.run args
      end

      it "should return the message that says the model output dir must be a valid directory (--model-output-dir /zzz)" do
        output.should_receive(:puts).with("-mod | --model-output-dir requires a valid directory")

        args = [ "-i", "text",  "--language","c_sharp", "--model-output-dir", "/zzz", "-sf", File.join(File.dirname(__FILE__),"data/allstar.txt")]
	cmd_line.run args
      end

      it "should return the message that says the service output dir must be a valid directory (-sod)"  do
        output.should_receive(:puts).with("-sod | --service-output-dir requires a valid directory")

        args = [ "-i", "text",  "--language","c_sharp", "-sod", "", "-sf", File.join(File.dirname(__FILE__),"data/allstar.txt")]
	cmd_line.run args
      end

      it "should return the message that says the service output dir must be a valid directory (--service-output-dir)" do
        output.should_receive(:puts).with("-sod | --service-output-dir requires a valid directory")

        args = [ "-i", "text",  "--language","c_sharp", "--service-output-dir", "", "-sf", File.join(File.dirname(__FILE__),"data/allstar.txt")]
	cmd_line.run args
      end

      it "should return the message that says the service output dir must be a valid directory (--service-output-dir /zzz)" do
        output.should_receive(:puts).with("-sod | --service-output-dir requires a valid directory")

        args = [ "-i", "text",  "--language","c_sharp", "--service-output-dir", "/zzz", "-sf", File.join(File.dirname(__FILE__),"data/allstar.txt")]
	cmd_line.run args
      end

      it "should return the message that says the imports requires at least one library (-imp)" do
        output.should_receive(:puts).with("-imp | --imports requires at least a name and can be a comma-delimeted list")

        args = [ "-i", "text",  "--language","c_sharp", "-imp", "" , "-sf", File.join(File.dirname(__FILE__),"data/allstar.txt")]
	cmd_line.run args
      end

      it "should return the message that says the imports requires at least one library (--imports)" do
        output.should_receive(:puts).with("-imp | --imports requires at least a name and can be a comma-delimeted list")

        args = [ "-i", "text",  "--language","c_sharp", "--imports", "", "-sf", File.join(File.dirname(__FILE__),"data/allstar.txt")]
	cmd_line.run args
      end
    end

    describe "Utility Command Line Options" do
      it "should not display any output when the -q option is used" do
	output.should_not_receive(:puts)
        args = [ "-i", "text", "--language","c_sharp", "-q", "-sf", File.join(File.dirname(__FILE__),"data/allstar.txt")]
        cmd_line.run args
      end

      it "should not display any output when the --quiet option is used" do
	output.should_not_receive(:puts)
        args = [ "-i", "text", "--language","c_sharp", "--quiet", "-sf", File.join(File.dirname(__FILE__),"data/allstar.txt")]
        cmd_line.run args
      end

      it "should display the command-line options when the -h option is used" do
	check_for_print_usage(output)
        args = ["-h"]
        cmd_line.run args
      end

      it "should display the command-line options when the --help option is used" do
	check_for_print_usage(output)
        args = ["--help"]
        cmd_line.run args
      end
    end

    describe "2 layer option validations" do
      it "should display an error message when input type is text but no --source-file option has been provided" do 
        output.should_receive(:puts).with('A path to a source file is required')
	check_for_print_usage(output)
   
        args = ["-l", "ruby", "-i", "text"]
	cmd_line.run args
      end

      it "should display an error message when input type is text and an invalid file was provided with --source-file option" do
        output.should_receive(:puts).with("ERROR: '/lib/abcd' Is not a valid file.")
        output.should_receive(:puts).with('--source-file, -sf require a valid path to a file')
	check_for_print_usage(output)
   
        args = ["-l", "ruby", "-i", "text", "--source-file", '/lib/abcd']
	cmd_line.run args
      end

      it "should display an error message when input type is text and an invalid file was provided with -sf option" do
        output.should_receive(:puts).with("ERROR: '/zzz/fred.txt' Is not a valid file.")
        output.should_receive(:puts).with('--source-file, -sf require a valid path to a file')
	check_for_print_usage(output)
   
        args = ["-l", "ruby", "-i", "text", "-sf", "/zzz/fred.txt"]
	cmd_line.run args
      end
    end
  end
end
