require 'ripper'
module ConstantExtractor
  # The digger class is a file parser meant to `dig` into a project and find all
  # the places a class or module is called from. An object is returned containing
  # a mapping of all the places classes and modules have been called.
  #
  # The digger mapping can then be used to check the dependency boundaries one
  # may enforce on a large project.
  class Digger
    def initialize(filepath)
      @ruby = File.read(filepath)
      @ast = Ripper.sexp(@ruby)
    end

    def search()
      @collector = {}
      dig(@ast)
      @collector
    end

    def dig(sexp)
      if sexp
        if (!sexp.is_a?(Array)) || (sexp.is_a?(Array) && sexp.first.is_a?(Symbol))
          name, *children = sexp
          children.each { |c| process(c); dig(c) }
        else
          sexp.each { |c| process(c); dig(c) }
        end
      end
    end

    def process(node)
      node_name = node.first

      on_handler = :"on_#{node_name}"

      if respond_to? on_handler
        new_node = send on_handler, node
      else
        new_node = nil
      end

      return new_node if new_node

      nil
    end

    def on_const(node)
      node[1]
    end

    def on_const_path_ref(node)
      name, *children = node

      path = children.map do |child|
        process(child)
      end

      const_name = path.join('::')
      @collector[name] ? @collector[name] << const_name : [const_name]

      const_name
    end

    def on_var_ref(node)
      name, *children = node

      children.map do |child|
        process(child)
      end
    end
  end
end
