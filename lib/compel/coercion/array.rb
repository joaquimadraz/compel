module Compel
  module Coercion

    class Array < Type

      def coerce!
        if !value.is_a?(::Array)
          fail
        end

        value
      end

    end

  end
end
