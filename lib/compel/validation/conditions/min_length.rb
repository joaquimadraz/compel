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
        !value.nil? && option_value <= "#{value}".length
      end

    end

  end
end
