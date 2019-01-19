require "constant_extractor/version"
require "parser/current"
require "ast"
require 'pry'

module ConstantExtractor
  class Error < StandardError; end

  def self.process(filepath)
    ruby_code = File.read(filepath)
    ast = Parser::CurrentRuby.parse(ruby_code, filepath)
    ConstructorProcessor.process(ast)
  end

  class ConstructorProcessor
    include AST::Processor::Mixin

    def self.process(node)
      new.process(node)
    end

    def process_regular_node(node)
      nodes = process_all(node).compact.flatten
      name = nodes.detect { |n| n.type == :name }

      if nodes.length == 1
        AST::Node.new(node.type, name.children)
      else
        child_nodes = nodes.select { |n| n.type == :class || n.type == :module }
        new_nodes = child_nodes.each_with_object([AST::Node.new(node.type, name.children)]) do |n, a|
          a << AST::Node.new(n.type,["#{name.children.first}::#{n.children.first}".to_sym])
        end
        new_nodes
      end
    end

    def on_const(node)
      scope_node, name = *node
      AST::Node.new(:name, [name])
    end

    def on_begin(node)
      nodes = process_all(node).compact

      !nodes.empty? ? nodes.flatten : nil
    end

    def process(node)
      return if node.nil?

      node = node.to_ast

      # Invoke a specific handler
      on_handler = :"on_#{node.type}"
      if respond_to? on_handler
        new_node = send on_handler, node
      else
        new_node = handler_missing(node)
      end

      return new_node if new_node

      nil
    end

    alias on_module         process_regular_node
    alias on_class          process_regular_node
  end
end
