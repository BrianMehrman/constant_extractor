require "constant_extractor/version"
require "parser/current"
require "ast"
require 'pry'
require 'constant_extractor/digger'
require 'constant_extractor/constructor_processor'

module ConstantExtractor
  class Error < StandardError; end

  def self.process(filepath)
    ruby_code = File.read(filepath)
    ast = Parser::CurrentRuby.parse(ruby_code, filepath)
    ConstructorProcessor.process(ast)
  end
end
