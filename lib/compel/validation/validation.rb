require 'compel/validation/conditions/condition'
require 'compel/validation/conditions/is'
require 'compel/validation/conditions/in'
require 'compel/validation/conditions/min'
require 'compel/validation/conditions/max'
require 'compel/validation/conditions/format'
require 'compel/validation/conditions/length'
require 'compel/validation/conditions/min_length'
require 'compel/validation/conditions/max_length'

module Compel

  module Validation

    KLASS_MAPPING = {
      is: Validation::Is,
      in: Validation::In,
      min: Validation::Min,
      max: Validation::Max,
      range: Validation::Range,
      within: Validation::Within,
      format: Validation::Format,
      length: Validation::Length,
      min_length: Validation::MinLength,
      max_length: Validation::MaxLength,
    }

    def validate(value, type, options)
      if value.nil? && !!options[:required]
        return ['is required']
      end

      errors = []

      options.each do |option, option_value|
        if KLASS_MAPPING.keys.include?(option.to_sym)
          message = KLASS_MAPPING[option.to_sym].new(value, option_value, type: type).validate
          errors << message if message
        end
      end

      errors
    end

    extend self

  end

end
