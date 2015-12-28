module Compel
  module Validators

    class Base

      attr_reader :input,
                  :output,
                  :errors,
                  :schema

      def initialize(input, schema)
        @input = input
        @schema = schema
      end

      def valid?
        @errors.empty?
      end

    end

  end
end
