module Compel
  module Coercion

    class Type

      attr_accessor :value,
                    :options

      def self.coerce(value, options = {})
        new(value, options).coerce
      end

      def initialize(value, options = {})
        @value = value
        @options = options
      end

      def coerce
        result = coerce_value

        # There are some special cases that
        # we need to build a custom error
        if result.is_a?(Result)
          return result
        end

        Coercion::Result.new(result, value, self.class)
      end

    end

  end
end
