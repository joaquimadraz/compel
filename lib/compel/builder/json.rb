module Compel
  module Builder

    class JSON < Schema

      def initialize
        super(Coercion::JSON)
      end

    end

  end
end
