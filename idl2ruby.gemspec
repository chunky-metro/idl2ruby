# frozen_string_literal: true

require_relative "lib/idl2ruby/version"

Gem::Specification.new do |s|
  s.name = "idl2ruby"
  s.version = Idl2ruby::VERSION
  s.authors = ["rhiza"]
  s.email = ["rhiza"]
  s.homepage = "https://github.com/chunky-metro/idl2ruby"
  s.summary = "Generate Ruby clients from Anchor IDL files"
  s.description = "Generate Ruby clients from Anchor IDL files for use with Solana programs"

  s.metadata = {
    "bug_tracker_uri" => "https://github.com/chunky-metro/idl2ruby/issues",
    "changelog_uri" => "https://github.com/chunky-metro/idl2ruby/blob/main/CHANGELOG.md",
    "documentation_uri" => "https://github.com/chunky-metro/idl2ruby",
    "homepage_uri" => "https://github.com/chunky-metro/idl2ruby",
    "source_code_uri" => "https://github.com/chunky-metro/idl2ruby"
  }

  s.license = "CC0"

  s.files = Dir.glob("lib/**/*") + Dir.glob("bin/**/*") + %w[README.md LICENSE.txt CHANGELOG.md]
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 3.0"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"

  s.add_dependency "borsh-rb"

end
