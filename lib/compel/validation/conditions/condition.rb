module Compel
  module Validation

    class Condition

      attr_reader :value,
                  :options,
                  :value_type,
                  :option_value

      def self.validate(value, option_value, options = {})
        new(value, option_value, options).validate
      end

      def initialize(value, option_value, options = {})
        @value = value
        @value_type = options.delete(:type) || Coercion::Types::Any
        @option_value = option_value
      end

      def validate
        # result is an error message
        result = validate_value

        Validation::Result.new(value, value_type, result)
      end

    end

  end
end
