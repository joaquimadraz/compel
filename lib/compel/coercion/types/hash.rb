module Compel
  module Coercion

    class Hash < Type

      def coerce_value
        if ::Hash.try_convert(value)
          symbolyze_keys(value)
        end
      end

      private

      def symbolyze_keys(hash)
        {}.tap do |symbolyzed_hash|
          hash.each do |key, value|
            symbolyzed_hash[key.to_sym] = value
          end
        end
      end
    end

  end
end
