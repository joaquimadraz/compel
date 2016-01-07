module Compel
  module Coercion

    class Any < Type

      def coerce_value
        value
      end

    end

  end
end
