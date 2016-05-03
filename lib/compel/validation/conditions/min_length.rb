module Compel
  module Validation

    class MinLength < Condition

      def validate_value
        unless valid?
          "cannot have length less than #{option_value}"
        end
      end

      private

      def valid?
        unless value.nil?
          _value = value.is_a?(Array) || value.is_a?(Hash) ? value.dup : "#{value}"

          return option_value <= _value.length
        end

        true
      end

    end

  end
end
