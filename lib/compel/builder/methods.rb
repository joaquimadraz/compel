require 'compel/builder/common'
require 'compel/builder/common_value'
require 'compel/builder/schema'
require 'compel/builder/hash'
require 'compel/builder/string'
require 'compel/builder/integer'
require 'compel/builder/float'
require 'compel/builder/datetime'
require 'compel/builder/boolean'

module Compel
  module Builder

    module Methods

      def hash
        Builder::Hash.new
      end

      def string
        Builder::String.new
      end

      def integer
        Builder::Integer.new
      end

      def float
        Builder::Float.new
      end

      def datetime
        Builder::DateTime.new
      end

      def boolean
        Builder::Boolean.new
      end

      extend self

    end

  end
end
