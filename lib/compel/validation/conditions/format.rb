module Compel
  module Validation

    class Format < Condition

      def validate
        if value_type == Coercion::String && !valid?
          "must match format #{option_value.source}"
        end
      end

      private

      def valid?
        !value.nil? && value =~ option_value
      end

    end

  end
end
