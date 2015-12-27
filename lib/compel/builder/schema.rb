module Compel
  module Builder

    class Schema

      include Builder::Common

      attr_reader :type,
                  :options

      def initialize(type)
        @type = type
        @options = Hashie::Mash.new
      end

      def required?
        !!options[:required]
      end

    end

  end
end
