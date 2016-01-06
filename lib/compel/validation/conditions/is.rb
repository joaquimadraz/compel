module Compel
  module Validation

    class Is < Condition

      def option_value
        if value_type == Coercion::Hash
          return @option_value.to_hash
        end

        @option_value
      end

      def validate
        unless valid?
          "must be #{option_value}"
        end
      end

      private

      def valid?
        value == option_value
      end

    end

  end
end
