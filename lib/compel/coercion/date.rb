module Compel
  module Coercion

    class Date < Type

      def coerce
        ::Date.parse(value)
      end

    end

  end
end
