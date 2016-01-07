module Compel
  module Validation

    class Min < Condition

      def validate
        unless valid?
          "cannot be less than #{option_value}"
        end
      end

      private

      def valid?
        !value.nil? && value >= option_value
      end

    end

  end
end
