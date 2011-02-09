require File.dirname(__FILE__) + '/../lib/string'

class GenericDomainSrcGenerator
  def initialize(domain_src_settings)
    require File.dirname(__FILE__) + "/#{domain_src_settings.output_settings[:language]}/domain_generator"
    @domain_src_settings = domain_src_settings
    @src_generator = DomainGenerator.new domain_src_settings
  end

  def generate_code
    @src_generator.generate_code
  end
end

