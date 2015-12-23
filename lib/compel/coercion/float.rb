module Compel
  module Coercion

    class Float < Type

      def coerce
        Float(value)
      end

    end

  end
end
