module Compel
  module Builder

    class String < Schema

      include CommonValue

      def initialize
        super(Coercion::String)
      end

      def format(regex)
        options[:format] = Coercion.coerce!(regex, Coercion::Regexp)
        self
      end

      def min_length(value)
        options[:min_length] = Coercion.coerce!(value, Coercion::Integer)
        self
      end

      def max_length(value)
        options[:max_length] = Coercion.coerce!(value, Coercion::Integer)
        self
      end

    end

  end
end
