module Compel
  module Coercion

    class Array < Type

      def coerce_value
        if value.is_a?(::Array)
          value
        end
      end

    end

  end
end
