 module Compel
  module Coercion

    class Result

      attr_reader :coerced,
                  :value,
                  :klass,
                  :error

      def initialize(coerced, value, klass, coercion_error = nil)
        @coerced = coerced
        @value = value
        @klass = klass
        @error = coercion_error.nil? ? standard_error : coercion_error
      end

      def valid?
        @error.nil?
      end

      private

      def standard_error
        if !klass.nil? && coerced.nil?
          "'#{value}' is not a valid #{klass_final_type}"
        end
      end

      def klass_final_type
        "#{klass}".split('::')[-1]
      end

    end

  end
end
