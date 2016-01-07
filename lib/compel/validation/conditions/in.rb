module Compel
  module Validation

    class In < Condition

      def validate_value
        unless valid?
          "must be within #{option_value}"
        end
      end

      private

      def valid?
        option_value.include?(value)
      end

    end

    class Within < In; end

    class Range < In; end

  end
end
