# frozen_string_literal: true

require "idl2ruby/version"
require "idl2ruby/railtie" if defined?(Rails::Railtie)

require_relative "idl2ruby/version"
require_relative "idl2ruby/types"
require_relative "idl2ruby/parser"
require_relative "idl2ruby/generator"

module Idl2Ruby
  class Error < StandardError; end

  def self.generate(idl_json)
    idl = Parser.parse(idl_json)
    Generator.generate(idl)
  end
end