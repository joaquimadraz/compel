module Compel
  module Validation

    class Max < Condition

      def validate_value
        unless valid?
          "cannot be greater than #{option_value}"
        end
      end

      private

      def valid?
        !value.nil? && value <= option_value
      end

    end

  end
end
