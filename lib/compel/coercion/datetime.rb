module Compel
  module Coercion

    class DateTime < Type

      def coerce
        ::DateTime.parse(value)
      end

    end

  end
end
