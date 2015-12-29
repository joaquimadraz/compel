module Compel
  module Coercion

    class Hash < Type

      def coerce_value
        Hashie::Mash.new(value).to_hash rescue nil
      end

    end

  end
end
