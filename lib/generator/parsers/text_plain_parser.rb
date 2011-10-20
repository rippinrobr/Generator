require 'json/ext'

module Generator
  module Parsers
    class InputParser
      def name 
        "JsonParser"
      end

      def parse(content)
        JSON.parse content.gsub(/""/,'"')
      end
    end
  end
end
