require 'compel/validation/conditions/condition'
require 'compel/validation/conditions/is'
require 'compel/validation/conditions/in'
require 'compel/validation/conditions/min'
require 'compel/validation/conditions/max'
require 'compel/validation/conditions/format'
require 'compel/validation/conditions/length'
require 'compel/validation/conditions/min_length'
require 'compel/validation/conditions/max_length'
require 'compel/validation/conditions/if'

require 'compel/validation/result'

module Compel

  module Validation

    CONDITIONS = {
      is: Validation::Is,
      in: Validation::In,
      min: Validation::Min,
      max: Validation::Max,
      range: Validation::Range,
      format: Validation::Format,
      length: Validation::Length,
      min_length: Validation::MinLength,
      max_length: Validation::MaxLength,
      if: Validation::If,
    }

    def validate(value, type, options)
      if value.nil? && !!options[:required]
        return ['is required']
      end

      errors = Errors.new

      options.each do |option, option_value|
        next unless condition_exists?(option)

        result = condition_klass(option).validate(value, option_value, type: type)

        unless result.valid?
          errors.add :base, result.error_message
        end
      end

      errors.to_hash[:base] || []
    end

    def condition_exists?(option)
      CONDITIONS.keys.include?(option.to_sym)
    end

    def condition_klass(option)
      CONDITIONS[option.to_sym]
    end

    extend self

  end

end
