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
        build_option :if, coerce_if_proc(lambda || block), options

        rescue
          raise Compel::TypeError, 'invalid proc for if'
      end

      # this is lovely, refactor later
      def coerce_if_proc(proc)
        if proc && proc.is_a?(Proc) &&
          (proc.arity == 1 || proc.arity == 0 &&
            (proc.call.is_a?(::Symbol) || proc.call.is_a?(::String)))
          proc
        else
          fail
        end
      end

    end

  end
end
