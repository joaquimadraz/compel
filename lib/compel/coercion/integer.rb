module Compel
  module Coercion

    class Integer < Type

      def coerce!
        Integer(value)
      end

    end

  end
end
