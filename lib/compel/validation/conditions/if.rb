module Compel
  module Validation

    class If < Condition

      def validate_value
        unless valid?
          "#{value} is invalid"
        end
      end

      private

      def valid?
        eval("#{option_value.call}(#{value})", option_value.binding)
      end

    end

  end
end
