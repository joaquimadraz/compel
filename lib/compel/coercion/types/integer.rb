module Compel
  module Coercion

    class Integer < Type

      def coerce_value
        Integer(value) rescue nil
      end

    end

  end
end
