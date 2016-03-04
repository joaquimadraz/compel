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
        hash.keys.each_with_object({}) do |key, symbolyzed_hash|
          symbolyzed_hash[key.to_sym] = hash[key]
        end
      end
    end

  end
end

