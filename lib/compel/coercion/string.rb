module Compel
  module Coercion

    class String < Type

      def coerce!
        if !value.is_a?(::String)
          fail
        end

        value
      end

    end

  end
end
