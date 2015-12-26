module Compel
  module Coercion

    class Time < Type

      def coerce!
        ::Time.parse(value)
      end

    end

  end
end
