module Compel
  module Coercion

    class String < Type

      def coerce_value
        if value.is_a?(::String)
          value
        end
      end

    end

  end
end
