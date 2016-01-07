 module Compel
  module Validation

    class Result

      attr_reader :value,
                  :klass,
                  :error_message

      def initialize(value, klass, error_message = nil)
        @value = value
        @klass = klass
        @error_message = error_message
      end

      def valid?
        @error_message.nil?
      end

    end

  end
end
