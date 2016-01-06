module Compel
  module Builder

    class Hash < Schema

      def initialize
        super(Coercion::Hash)

        options[:keys] = {}
      end

      def keys(hash)
        options[:keys] = hash
        self
      end

    end

  end
end
