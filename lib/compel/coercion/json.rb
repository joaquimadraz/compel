module Compel
  module Coercion

    class JSON < Type

      def coerce
        ::JSON.parse(value)
      end

    end

  end
end
