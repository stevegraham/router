require 'set'

class Router
  module Trie
    class Node
      def initialize(key: '', parent: nil)
        @children = Set.new
        @parent   = parent
        @key      = key
      end

      attr_reader   :children, :key, :parent
      attr_accessor :value

      def siblings
        parent.children
      end

      def find key
        _find(key.split '/')
      end

      def add key, value
        (find(key) || attach(key)).tap { |node| node.value = value }
      end

      def hash
        key.hash
      end

      protected

      def _find keys
        tail  = keys[1..-1]
        node  = node_for keys.first

        if tail.any?
          node && node._find(tail)
        else
          node
        end
      end

      def attach key
        _attach key.split '/'
      end

      def _attach keys
        tail  = keys[1..-1]
        node = node_for keys.first

        unless node
          node = Node.new(key: keys.first, parent: self)
          children << node
        end

        tail.any? ? node._attach(tail) : node
      end

      def node_for key
        children.detect { |child| child.key == key }
      end
    end
  end
end
