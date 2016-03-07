module Compel
  module Coercion

    class DateType < Type

      attr_reader :format

      def coerce_value
        @format = default_format

        if options[:format]
          @format = options[:format][:value]
        end

        if value.is_a?(klass)
          @value = value.strftime(format)
        end

        coerced = klass.strptime(value, format)

        if coerced.strftime(format) == value
          return coerced
        end

        build_error_result

        rescue
          build_error_result
      end

      def build_error_result
        custom_error = "'#{value}' is not a parsable #{klass.to_s.downcase} with format: #{format}"

        Result.new(nil, value, self.class, custom_error)
      end

    end

  end
end
