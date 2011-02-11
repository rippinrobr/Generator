require 'net/http'
require 'uri'

module Generator
  module Utils
    class UrlManager
      def get_page(uri)
        url = URI.parse uri
        req = Net::HTTP::Get.new(url.path)
        Net::HTTP.start( url.host, url.port ) { |http| http.request(req) } 
      end
    end
  end
end
