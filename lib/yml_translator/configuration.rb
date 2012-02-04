module YMLTranslator
  def self.config
    @config ||= Configuration.new
  end

  class Configuration
    attr_accessor :api_key
  end
end
