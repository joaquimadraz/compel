module Compel
  module Validation

    class MaxLength < Condition

      def validate_value
        unless valid?
          "cannot have length greater than #{option_value}"
        end
      end

      private

      def valid?
        unless value.nil?
          _value = value.is_a?(Array) || value.is_a?(Hash) ? value.dup : "#{value}"

          return _value.length <= option_value
        end

        true
      end

    end

  end
end
