module Compel
  module Builder

    module Common

      def is(value)
        build_option :is, Coercion.coerce!(value, self.type)

        self
      end

      def required
        build_option :required, true

        self
      end

      def default(value)
        build_option :default, Coercion.coerce!(value, self.type)

        self
      end

      def length(value)
        build_option :length, Coercion.coerce!(value, Coercion::Integer)

        self
      end

      def min_length(value)
        build_option :min_length, Coercion.coerce!(value, Coercion::Integer)

        self
      end

      def max_length(value)
        build_option :max_length, Coercion.coerce!(value, Coercion::Integer)

        self
      end

    end

  end
end
