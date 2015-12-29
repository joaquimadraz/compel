module Compel
  module Coercion

    class JSON < Type

      def coerce_value
        ::JSON.parse(value) rescue nil
      end

    end

  end
end
