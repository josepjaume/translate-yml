# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yml_translator/version"

Gem::Specification.new do |s|
  s.name        = "yml_translator"
  s.version     = Translate::Yml::VERSION
  s.authors     = ["Josep Jaume"]
  s.email       = ["josepjaume@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "yml_translator"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "minitest"
  s.add_development_dependency 'minitest-reporters'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'fakefs'

  s.add_runtime_dependency "to_lang"
  s.add_runtime_dependency "slop"
end
