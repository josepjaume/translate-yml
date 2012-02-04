require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'

require 'yml_translator/configuration'

YMLTranslator.config.api_key = File.read('spec/api_key').strip

MiniTest::Unit.runner = MiniTest::SuiteRunner.new
MiniTest::Unit.runner.reporters << MiniTest::Reporters::SpecReporter.new
