module Compel
  module Coercion

    class Regexp < Type

      def coerce!
        if value.is_a?(::Regexp)
          return value
        end

        fail
      end

    end

  end
end
