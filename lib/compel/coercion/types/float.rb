module Compel
  module Coercion

    class Float < Type

      def coerce_value
        Float(value) rescue nil
      end

    end

  end
end
