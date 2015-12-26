module Compel
  module Coercion

    class Boolean < Type

      def coerce!
        if /(false|f|no|n|0)$/i === "#{value}"
          return false
        end

        if /(true|t|yes|y|1)$/i === "#{value}"
          return true
        end

        fail
      end

    end

  end
end
