module Compel
  module Coercion

    class Hash < Type

      def coerce_value
        if ::Hash.try_convert(value)
          # Symbolize keys
          ::JSON.parse(value.to_json, symbolize_names: true)
        end
      end

    end

  end
end
