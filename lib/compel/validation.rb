module Compel

  module Validation

    def valid?(value, options)
      validate(value, options).length == 0
    end

    def validate!(value, options)
      errors = validate(value, options)

      if errors.length > 0
        raise ParamValidationError, errors[0]
      end
    end

    def validate(value, options)
      errors = []

      options.each do |option, option_value|
        # most of this code snippet is from sinatra-param gem
        # https://github.com/mattt/sinatra-param
        # by Mattt Thompson (@mattt)
        begin
          case option.to_sym
          when :required
            raise ParamValidationError, 'is required' if option_value && value.nil?
          when :blank
            raise ParamValidationError, 'cannot be blank' if !option_value && case value
            when String
              !(/\S/ === value)
            when Array, Hash
              value.empty?
            else
              value.nil?
            end
          when :format
            raise ParamValidationError, 'must be a string if using the format validation' unless value.kind_of?(String)
            raise ParamValidationError, "must match format #{option_value}" unless value =~ option_value
          when :is
            raise ParamValidationError, "must be #{option_value}" unless value === option_value
          when :in, :within, :range
            raise ParamValidationError, "must be within #{option_value}" unless value.nil? || case option_value
            when Range
              option_value.include?(value)
            else
              Array(option_value).include?(value)
            end
          when :min
            raise ParamValidationError, "cannot be less than #{option_value}" unless value.nil? || option_value <= value
          when :max
            raise ParamValidationError, "cannot be greater than #{option_value}" unless value.nil? || option_value >= value
          when :length
            raise ParamValidationError, "cannot have length different than #{option_value}" unless value.nil? || option_value == "#{value}".length
          when :min_length
            raise ParamValidationError, "cannot have length less than #{option_value}" unless value.nil? || option_value <= value.length
          when :max_length
            raise ParamValidationError, "cannot have length greater than #{option_value}" unless value.nil? || option_value >= value.length
          end
        rescue ParamValidationError => exception
          errors << exception.message
        end
      end

      errors
    end

    extend self

  end

end
