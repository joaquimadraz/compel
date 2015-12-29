module Compel
  module Coercion

    class Boolean < Type

      def coerce_value
        if /(false|f|no|n|0)$/i === "#{value}"
          return false
        end

        if /(true|t|yes|y|1)$/i === "#{value}"
          return true
        end
      end

    end

  end
end
