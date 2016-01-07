module Compel
  module Validation

    class MaxLength < Condition

      def validate
        unless valid?
          "cannot have length greater than #{option_value}"
        end
      end

      private

      def valid?
        !value.nil? && "#{value}".length <= option_value
      end

    end

  end
end
