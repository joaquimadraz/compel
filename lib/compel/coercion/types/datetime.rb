module Compel
  module Coercion

    class DateTime < Type

      attr_reader :format

      def coerce_value
        @format = options[:format] || '%FT%T'

        if value.is_a?(::DateTime)
          @value = value.strftime(format)
        end

        coerced = ::DateTime.strptime(value, format)

        if coerced.strftime(format) == value
          return coerced
        end

        build_error_result

        rescue
          build_error_result
      end

      def build_error_result
        custom_error = "'#{value}' is not a parsable datetime with format: #{format}"

        Result.new(nil, value, self.class, custom_error)
      end

    end

  end
end
