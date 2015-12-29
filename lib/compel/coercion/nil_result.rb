 module Compel
  module Coercion

    class NilResult < Result

      def initialize
        super(nil, nil, nil)
      end

    end

  end
end
