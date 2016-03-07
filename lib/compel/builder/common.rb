module Compel
  module Builder

    module Common

      def is(value, options = {})
        build_option :is, Coercion.coerce!(value, self.type)
      end

      def required
        build_option :required, true, options
      end

      def default(value, options = {})
        build_option :default, Coercion.coerce!(value, self.type), options
      end

      def length(value, options = {})
        build_option :length, Coercion.coerce!(value, Coercion::Integer), options
      end

      def min_length(value, options = {})
        build_option :min_length, Coercion.coerce!(value, Coercion::Integer), options
      end

      def max_length(value, options = {})
        build_option :max_length, Coercion.coerce!(value, Coercion::Integer), options
      end

    end

  end
end
