module Compel
  module Validation

    class Condition

      attr_reader :value,
                  :options,
                  :value_type,
                  :option_value

      def initialize(value, option_value, options = {})
        @value = value
        @value_type = options.delete(:type) || Coercion::Types::Any
        @option_value = option_value
      end

    end

  end
end
