module Compel
  module Builder

    module Common

      def is(value)
        build_option :is, Coercion.coerce!(value, self.type)
      end

      def required
        build_option :required, true
      end

      def default(value)
        build_option :default, Coercion.coerce!(value, self.type)
      end

      def length(value)
        build_option :length, Coercion.coerce!(value, Coercion::Integer)
      end

      def min_length(value)
        build_option :min_length, Coercion.coerce!(value, Coercion::Integer)
      end

      def max_length(value)
        build_option :max_length, Coercion.coerce!(value, Coercion::Integer)
      end

    end

  end
end
