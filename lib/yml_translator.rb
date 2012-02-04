require "yml_translator/version"
require 'json'

module YMLTranslator
  def self.translate_file(file, options)
    data = YAML.load_file(file)
    translator = Translator.new(
      from: options[:from],
      to: options[:to],
      api_key: YMLTranslator.config.api_key
    )
    translator.translate(data)
  end
end

require 'yml_translator/configuration'
require 'yml_translator/translator'
