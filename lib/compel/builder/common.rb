module Compel
  module Builder

    module Common

      def is(value)
        options[:is] = Coercion.coerce!(value, self.type)
        self
      end

      def required
        options[:required] = true
        self
      end

      def default(value)
        options[:default] = Coercion.coerce!(value, self.type)
        self
      end

      def length(value)
        options[:length] = Coercion.coerce!(value, Coercion::Integer)
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
