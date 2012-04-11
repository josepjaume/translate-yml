require 'to_lang'
require 'google_translate'

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
      puts "Translating: \"#{string}\""
      translated = replace_interpolations(string) do |text|
        translate_with_fallbacks(text)
      end
      puts "Translated: \"#{translated}\""
      translated
    end

    def replace_interpolations(text)
      index = 0
      replacements = {}
      text.gsub!(/(%{.*})/) do |string|
        index += 1
        replacement = "REPLACEMENT#{index}"
        replacements[replacement] = string
        replacement
      end
      text = yield(text)
      replacements.each do |key, value|
        text.sub!(key, value)
      end
      text
    end
    private :replace_interpolations

    def translate_with_fallbacks(string)
      translate_with_api(string) || translate_scraping(string) || string
    end

    def translate_with_api(string)
      translated = string.translate(to, from: from)
      translated.sub!("% {", "%{")
      translated.strip
    rescue
      nil
    end

    def translate_scraping(string)
      translated = Google::Translator.new.translate(from, to, string)
      translated = translated[0] if translated
      translated.strip
    rescue
      nil
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
