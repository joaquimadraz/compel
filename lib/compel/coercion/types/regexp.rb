module Compel
  module Coercion

    class Regexp < Type

      def coerce_value
        if value.is_a?(::Regexp)
          value
        end
      end

    end

  end
end
