module Compel
  module Coercion

    class Hash < Type

      def coerce!
        Hashie::Mash.new(value).to_hash
      end

    end

  end
end
