module Compel
  module Validation

    class Length < Condition

      def validate
        unless valid?
          "cannot have length different than #{option_value}"
        end
      end

      private

      def valid?
        !value.nil? && option_value == "#{value}".length
      end

    end

  end
end
