require_relative '../utils/string'

class GenericDomainSrcGenerator
  def initialize(domain_src_settings)
    load  "lib/generator/languages/#{domain_src_settings.output_settings[:language]}/domain_generator.rb"
    @domain_src_settings = domain_src_settings
    @src_generator = DomainGenerator.new domain_src_settings
  end

  def generate_code
    @src_generator.generate_code
  end
end

