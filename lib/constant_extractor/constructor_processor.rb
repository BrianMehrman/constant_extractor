module ConstantExtractor
  # This processor class is for extracting the classes and modules from a ruby
  # file.
  class ConstructorProcessor
    include AST::Processor::Mixin

    def self.process(node)
      new.process(node)
    end

    # Process the module or class nodes to extract the fully qualified name.
    # param node [AST::Node] - accepts an node to process module or class nodes.
    # returns [Array] - of AST nodes
    def process_constant_node(node)
      nodes = process_all(node).compact.flatten
      name = nodes.detect { |n| n.type == :name }

      if nodes.length == 1
        [AST::Node.new(node.type, name.children)]
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

    alias on_module         process_constant_node
    alias on_class          process_constant_node
  end
end
