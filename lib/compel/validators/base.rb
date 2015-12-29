module Compel
  module Validators

    class Base

      attr_reader :input,
                  :output,
                  :errors,
                  :schema

      def initialize(input, schema)
        @input = input.nil? ? schema.default_value : input
        @schema = schema
        @output = nil
      end

      def valid?
        @errors.empty?
      end

    end

  end
end
