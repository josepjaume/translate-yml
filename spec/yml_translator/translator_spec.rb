# encoding: utf-8
#
require_relative '../spec_helper'
require 'yml_translator/translator'
require 'mocha'

describe YMLTranslator::Translator do
  subject do
    YMLTranslator::Translator.new(
      from: :en,
      to: :es,
      api_key: 'fake_key'
    )
  end

  describe "#initialize" do
    it "initializes ToLang" do
      ToLang.expects(:start).with('fake_key')
      subject
    end
  end

  describe "#from" do
    it "returns the origin language" do
      subject.from.must_equal :en
    end
  end

  describe "#to" do
    it "returns the origin language" do
      subject.to.must_equal :es
    end
  end

  describe "#translate_string" do
    it "translates a string" do
      string = "Hi"
      string.expects(:translate).with(:es, from: :en).returns("Hola")
      translated = subject.translate_string(string)
      translated.must_equal "Hola"
    end

    it "translates a string with interpolations" do
      subject.expects(:translate_string).
        with("Hi, %{name}").returns("Hola, %{name}")
      translated = subject.translate_string("Hi, %{name}")
      translated.must_equal "Hola, %{name}"
    end
  end

  describe "#translate_array" do
    it "translates an array" do
      subject.expects(:translate_string).
        with('Hi').returns("Hola")
      subject.expects(:translate_string).
        with('Teacher').returns("Profesor")

      array = ["Hi", "Teacher"]
      translated = subject.translate_array(array)
      translated.must_equal ["Hola", "Profesor"]
    end
  end

  describe "#translate_hash" do
    it "translates an array" do
      subject.expects(:translate_string).
        with('Hi').returns("Hola")
      subject.expects(:translate_string).
        with('Teacher').returns("Profesor")

      hash = {first: "Hi", second: "Teacher"}
      translated = subject.translate_hash(hash)
      translated.must_equal(first: "Hola", second: "Profesor")
    end
  end

  describe "integration" do
    it "translates a tree" do
      subject.expects(:translate_string).
        with('Hi').returns("Hola")
      subject.expects(:translate_string).
        with('Teacher').returns("Profesor")
      subject.expects(:translate_string).
        with('My taylor is rich').returns("Mi sastre es rico")

      tree = {
        first: "Hi",
        second: {
          sub: ['Teacher', 'My taylor is rich']
        }
      }
      subject.translate(tree).must_equal(
        {:first=>"Hola", :second=>{:sub=>["Profesor", "Mi sastre es rico"]}}
      )
    end
  end
end
