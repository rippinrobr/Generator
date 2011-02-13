module Generator
  class CmdLine
    attr_accessor :options

    def initialize(output)
      @output  = output
      @options = Hash.new

      @options[:input_type]     = nil
      @options[:language]       = nil

      @valid_languages            = []
      @valid_input_types          = []
      @valid_model_output_options = ["emit", "src"]

      @error_messages    = [] 

      get_valid_languages
      get_valid_sources
    end

    def run(args=[])
      if args.length < 4 
        print_usage
        return
      end
      if(process_args(args))
        require File.join(File.dirname(__FILE__), "sources/#{@options[:input_type]}/#{@options[:input_type]}_code_gen")

        engine = Engine.new @options
        engine.create_models unless @options[:model_output_dir].nil?
        engine.create_service_classes unless @options[:service_output_dir].nil?
      else
        @error_messages.each { |e| @output.puts e }
        print_usage
      end
    end

    private
    def print_usage()
      @output.puts 'Required Options:'
      @output.puts '--input-type, -i  url|text'
      @output.puts '	when using url -url followed by a valid URI to the input is required'
      @output.puts '	when using text --source-file or -sf followed by a path to the input file is required'
      @output.puts '--language, -l    ruby|c_sharp'
      @output.puts ''
      @output.puts 'Optional:'
      @output.puts '--service-output-dir, -sod  the name of the directory to place the service source' 
      @output.puts '--header, hd the text input has column headers'
      @output.puts '--help, -h  displays this message'
      @output.puts '--imports, -i   the name of the libraries to include in the generated source' 
      @output.puts '--model, -m  src | emit (.NET only) - indicates how you want the model code created'
      @output.puts '--model-output-dir, -mod  the name of the directory to place the model source/dll' 
      @output.puts '--model-class, -mc  the name of the model class' 
      @output.puts '--quite, -q  runs the script without writing output' 
    end

    def process_args(args)
      args.each do |arg| 
        case(arg)
          when "--input-type"
            return false if !valid_input_type(args, arg)
          when "-i" 
            return false if !valid_input_type(args, arg)
          when "--language" 
            return false if !valid_language(args, arg)
          when "-l" 
            return false if !valid_language(args, arg)
          #--- Optional Params from here down
          when "-sod"
            return false if !valid_service_output_dir(args, arg)
          when "--service-output-dir"
            return false if !valid_service_output_dir(args, arg)
          when "-sn"
            parse_service_namespace(args, arg)
          when "--service-namespace"
            parse_service_namespace(args, arg)
          when "-hd"
            @options[:header] = true
          when "--header"
            @options[:header] = true
          when "-h"
            return false 
          when "--help"
            return false 
          when "-imp"
            return false if !valid_imports_string(args, arg)
          when "--imports"
            return false if !valid_imports_string(args, arg)
          when "-m"
            return false if !valid_model_output_option(args, arg)
          when "--model"
            return false if !valid_model_output_option(args, arg)
          when "-mn"
            return false if !valid_model_namespace(args, arg)
          when "--model-namespace"
            return false if !valid_model_namespace(args, arg)
          when "-mc"
            return false if !valid_model_class(args, arg)
          when "--model-class"
            return false if !valid_model_class(args, arg)
          when "--model-namespace"
            return false if !valid_model_namespace(args, arg)
          when "-mod"
            return false if !valid_model_output_dir(args, arg)
          when "--model-output-dir"
            return false if !valid_model_output_dir(args, arg)
          when "-q" 
            @options[:quiet] = true
          when "--quiet" 
            @options[:quiet] = true
        end
      end

      !@options[:input_type].nil? && !@options[:language].nil?
    end

private
    def get_valid_languages
      base_dir = File.join(File.dirname(__FILE__), 'languages/')
      Dir.foreach(base_dir) do |dir|
        @valid_languages << dir if File.directory?("#{base_dir}#{dir}") && dir != ".." && dir != "."
      end
    end

    def get_valid_sources
      base_dir = File.join(File.dirname(__FILE__), 'sources/')
      Dir.foreach(base_dir) do |dir|
        @valid_input_types << dir if File.directory?("#{base_dir}#{dir}") && dir != ".." && dir != "."
      end
    end

    def is_valid_option?(option)
        !@options[option].nil? && @options[option].to_s != ''
    end

    def parse_service_namespace(args, switch)
      @options[:service_namespace] = args[args.index(switch)+1]
    end

    def set_full_path(path_to_set)
      if path_to_set[0] != '/' && path_to_set[1] != ':'
        "#{File.join(File.dirname(__FILE__), path_to_set)}"
      else
        path_to_set
      end
    end
    
    def validate_option(option, messages, &block)
      if !is_valid_option?(option) || (!block.nil? && !block.call )
        @error_messages << messages
        @options[option] = nil
        return false
      end
      true 
    end

    def valid_service_output_dir(args, switch)
      @options[:service_output_dir] = set_full_path(args[args.index(switch)+1])
      
      if @options[:service_output_dir].nil? || @options[:service_output_dir].to_s == "" ||
        !Dir.exists?(@options[:service_output_dir].to_s) || @options[:service_output_dir] == File.dirname(__FILE__)+"/"
        @error_messages << "-sod | --service-output-dir requires a valid directory"
        @options[:service_output_dir] = nil
      end 
      !@options[:service_output_dir].nil? && @options[:service_output_dir].to_s != ""
    end

    def valid_imports_string(args, switch)
      @options[:imports] = args[args.index(switch)+1]
      if @options[:imports] == '' || @options[:imports].nil? 
         @error_messages << "-imp | --imports requires at least a name and can be a comma-delimeted list" 
         @options[:imports] = nil
      end
    end

    def valid_input_type(args, switch)
      @options[:input_type] = args[args.index(switch)+1]
      if !@valid_input_types.include?(@options[:input_type].downcase)
        @error_messages = [] if @error_messages.nil?
        @error_messages << "Required Options Missing" 
      	@error_messages << "'#{@options[:input_type]}' is not a supported input type"
        @error_messages << "Supported Input Types: #{@valid_input_types.join(", ")}"

        return false
      end

      result = case @options[:input_type].to_s
        when "text" then validate_text_input(args)
        when "url" then validate_url_input(args)
        else false 
      end

      result
    end

    def valid_model_class(args, switch)
      @options[:model_class_name] = args[args.index(switch)+1]
      if @options[:model_class_name] == '' || @options[:model_class_name].nil? 
         @error_messages << "-mc | --model-class requires a name to follow" 
         @options[:model_class_name] = nil
         return false
      end
      true
    end

    def validate_text_input(args)
      if !args.include?("--source-file") && !args.include?("-sf")
        @error_messages << "A path to a source file is required"
        return false
      else
        source_file_index = -1
        source_file_index = args.index("--source-file") if !args.index("--source-file").nil?
        source_file_index = args.index("-sf") if source_file_index == -1
        @options[:source_file] = set_full_path(args[source_file_index+1])
        if @options[:source_file].nil? || !File.exists?(@options[:source_file])
          @error_messages << "ERROR: '#{@options[:source_file]}' Is not a valid file."
          @error_messages << "--source-file, -sf require a valid path to a file"
          return false
        end
      end
      true
    end

    def validate_url_input(args)
      if !args.include?("-url") 
        @error_messages << "A valid URL to source is required"
        return false
      else
        url_index = -1
        url_index = args.index("-url") if !args.index("-url").nil?
        @options[:url] = args[url_index+1]
        if @options[:url].nil? 
          @error_messages << "ERROR: '#{@options[:url]}' Is not a valid URI."
          @error_messages << "-url requires a valid URI"
          return false
        end
      end
      true
    end

    def valid_language(args, switch)
      @options[:language] = args[args.index(switch)+1]
      if !@valid_languages.include?(@options[:language].downcase)
        @error_messages << "Required Options Missing" 
      	@error_messages << "'#{@options[:language]}' is not a supported language"
        @error_messages << "Supported Languages: #{@valid_languages.join(", ")}"
        return false
      end
      true
    end
    def valid_model_namespace(args, switch)
      @options[:model_namespace] = args[args.index(switch)+1]
      if @options[:model_namespace].nil? || @options[:model_namespace].to_s == ""
        @error_messages << "-mn | --model-namespace requires a name"
      end 
      !@options[:model_namespace].nil? && @options[:model_namespace].to_s != ""
    end

    def valid_model_output_dir(args, switch)
      @options[:model_output_dir] = set_full_path(args[args.index(switch)+1])

      if @options[:model_output_dir].nil? || @options[:model_output_dir].to_s == "" ||
        !Dir.exists?(@options[:model_output_dir].to_s) || @options[:model_output_dir] == File.dirname(__FILE__)+"/"
        @error_messages << "-mod | --model-output-dir requires a valid directory"
        @options[:model_output_dir] = nil
      end 
      !@options[:model_output_dir].nil? && @options[:model_output_dir].to_s != ""
    end

    def valid_model_output_option(args, switch)
      @options[:model_output] = args[args.index(switch)+1]
      if !@valid_model_output_options.include?(@options[:model_output].downcase)
      	@error_messages << "'#{@options[:model_output]}' is not a supported output option"
        @error_messages << "Supported Output Options: #{@valid_model_output_options.join(", ")} (default)"
        return false
      end
      true
    end
  end
end
