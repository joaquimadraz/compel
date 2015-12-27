module Compel

  module Validation

    def validate(value, type, options)
      errors = []

      options.each do |option, option_value|
        # most of this code snippet is from sinatra-param gem
        # https://github.com/mattt/sinatra-param
        # by Mattt Thompson (@mattt)
        case option.to_sym
        when :required
          errors << 'is required' if option_value && value.nil?
        when :format
          if type == Coercion::String && !value.nil?
            errors << "must match format #{option_value.source}" unless value =~ option_value
          else
            errors << 'must be a string if using the format validation'
          end
        when :is
          errors << "must be #{option_value}" unless value === option_value
        when :in, :within, :range
          errors << "must be within #{option_value}" unless value.nil? || case option_value
          when Range
            option_value.include?(value)
          else
            Array(option_value).include?(value)
          end
        when :min
          errors << "cannot be less than #{option_value}" unless value.nil? || option_value <= value
        when :max
          errors << "cannot be greater than #{option_value}" unless value.nil? || option_value >= value
        when :length
          errors << "cannot have length different than #{option_value}" unless value.nil? || option_value == "#{value}".length
        when :min_length
          unless value.kind_of?(String)
            errors << 'must be a string if using the min_length validation'
          else
            errors << "cannot have length less than #{option_value}" unless value.nil? || option_value <= value.length
          end
        when :max_length
          unless value.kind_of?(String)
            errors << 'must be a string if using the max_length validation'
          else
            errors << "cannot have length greater than #{option_value}" unless value.nil? || option_value >= value.length
          end
        end
      end

      errors
    end

    extend self

  end

end
