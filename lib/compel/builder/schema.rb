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

      def default_value
        options[:default]
      end

      def validate(object)
        Contract.new(object, self).validate
      end

    end

  end
end
