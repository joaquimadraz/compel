module Compel
  module Builder

    class Schema

      include Builder::Common

      attr_reader :type,
                  :options

      def self.human_name
        "#{self.name.split('::')[1..-1].join('::')}"
      end

      def initialize(type)
        @type = type
        @options = default_options
      end

      def required?
        options[:required][:value]
      end

      def default_value
        options[:default][:value] if options[:default]
      end

      def validate(object)
        Contract.new(object, self).validate
      end

      def build_option(name, value, extra_options = {})
        options[name] = { value: value }.merge(extra_options)

        self
      end

      def default_options
        { required: { value: false } }
      end

    end

  end
end
