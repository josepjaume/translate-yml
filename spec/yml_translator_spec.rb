require 'yml_translator'
require 'fakefs/safe'
require 'mocha'

require_relative 'spec_helper'

describe YMLTranslator do
  subject{ YMLTranslator }
  describe "translate_file" do
    let(:hash) do
      {first: "Hi", last: "Teacher"}
    end

    before do
      FakeFS.activate!
      File.open('fake_file', 'w') do |f|
        f.write YAML.dump(hash)
      end
    end

    after do
      FakeFS.deactivate!
      FakeFS::FileSystem.clear
    end

    it "translates a file" do
      YMLTranslator::Translator.any_instance.
        expects(:translate_string).with('Hi').returns("Hola")
      YMLTranslator::Translator.any_instance.
        expects(:translate_string).with('Teacher').returns("Profesor")

      subject.translate_file(
        "fake_file",
        from: :en,
        to: :es
      ).must_equal({
        first: "Hola",
        last: "Profesor"
      })
    end
  end
end
