require 'to_lang'

module YMLTranslator
  class Translator
    attr_accessor :translator

    def initialize(options)
      @options = options
      ToLang.start(options[:api_key])
    end

    def from
      @options[:from].to_sym
    end

    def to
      @options[:to].to_sym
    end

    def translate(object)
      if object.kind_of?(String)
        translate_string(object)
      elsif object.kind_of?(Array)
        translate_array(object)
      elsif object.kind_of?(Hash)
        translate_hash(object)
      else
        object
      end
    end

    def translate_string(string)
      puts "Translating: #{string}"
      translated = string.translate(to, from: from)
      translated.sub!("% {", "%{")
      puts "Translated: \"#{translated}\""
      translated
    rescue RuntimeError
      require 'google_translate'
      translated = Google::Translator.new.translate(from, to, string)
      translated = translated[0] if translated
      puts "Translated: \"#{translated}\""
      translated.strip
    end

    def translate_array(array)
      array.map do |el|
        translate(el)
      end
    end

    def translate_hash(hash)
      result = {}
      hash.each do |key, value|
        result[key] = translate(value)
      end
      result
    end
  end
end
