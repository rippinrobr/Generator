require 'open-uri'

module Generator
  class Engine
    def initialize(options, output=STDOUT)
      @options = options
      @output = output
      @domain_classes_to_create = []
      @domain_to_model = Hash.new

      fetch_url
    end

    def create_models
    end

    def create_service_classes
    end

   private
    def fetch_url
     
      puts open(@options[:url]).read
    end
  end
end
