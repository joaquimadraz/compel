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
        @options = options
        @option_value = option_value
      end

      def validate
        Validation::Result.new \
          value, value_type, validate_value_with_error_message
      end

      private

      def validate_value_with_error_message
        error_message = validate_value

        if error_message
          error_message_with_value(options[:message] || error_message)
        end
      end

      def error_message_with_value(message)
        message.gsub(/\{\{value\}\}/, "#{value}")
      end

    end

  end
end
