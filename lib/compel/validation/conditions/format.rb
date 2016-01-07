module Compel
  module Validation

    class Format < Condition

      def validate_value
        if value_type == Coercion::String && !valid?
          "must match format #{option_value.source}"
        end
      end

      def valid?
        !value.nil? && value =~ option_value
      end

    end

  end
end
