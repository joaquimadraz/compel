require 'compel/validation/conditions/condition'
require 'compel/validation/conditions/is'
require 'compel/validation/conditions/in'
require 'compel/validation/conditions/format'

module Compel

  module Validation

    def validate(value, type, options)
      # if a value is required and not given,
      # don't do any other validation
      if !!options[:required] && value.nil?
        return ['is required']
      end

      errors = []

      options.each do |option, option_value|

        validation_klass = Compel::Validation.const_get("#{option.to_s.split('_').collect(&:capitalize).join}") rescue nil

        if validation_klass
          message = validation_klass.new(value, option_value, type: type).validate
          errors << message if message
        else
          # most of this code snippet is from sinatra-param gem
          # https://github.com/mattt/sinatra-param
          # by Mattt Thompson (@mattt)
          case option.to_sym
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
      end

      errors
    end

    extend self

  end

end
