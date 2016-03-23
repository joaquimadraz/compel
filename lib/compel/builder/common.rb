module Compel
  module Builder

    module Common

      def is(value, options = {})
        build_option :is, Coercion.coerce!(value, self.type), options
      end

      def required(options = {})
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

      def if(lambda = nil, options = {}, &block)
        value = \
          if lambda && lambda.is_a?(Proc) && lambda.arity == 1
            lambda
          elsif block && block.arity == 0 && (block.call.is_a?(::Symbol) || block.call.is_a?(::String))
            block
          else
            fail
          end

        build_option :if, value, options

        rescue
          raise Compel::TypeError, 'invalid proc for if'
      end

    end

  end
end
