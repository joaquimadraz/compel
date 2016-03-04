module Compel
  module Builder

    class Schema

      include Builder::Common

      attr_reader :type,
                  :options

      def initialize(type)
        @type = type
        @options = default_options
      end

      def required?
        options[:required]
      end

      def default_value
        options[:default]
      end

      def validate(object)
        Contract.new(object, self).validate
      end

      class << self

        def human_name
          "#{self.name.split('::')[1..-1].join('::')}"
        end

      end

      protected

      def default_options
        { required: false }
      end

    end

  end
end
