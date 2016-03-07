require 'compel/validation/conditions/condition'
require 'compel/validation/conditions/is'
require 'compel/validation/conditions/in'
require 'compel/validation/conditions/min'
require 'compel/validation/conditions/max'
require 'compel/validation/conditions/format'
require 'compel/validation/conditions/length'
require 'compel/validation/conditions/min_length'
require 'compel/validation/conditions/max_length'

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
    }

    def validate(value, type, options)
      if value.nil? && !!(options[:required] && options[:required][:value])
        return ['is required']
      end

      errors = Errors.new

      options.each do |name, option_values|
        next unless condition_exists?(name)

        cloned_options = option_values.dup

        option_value = cloned_options.delete(:value)

        result = condition_klass(name).validate \
          value, option_value, cloned_options.merge(type: type)

        unless result.valid?
          errors.add :base, result.error_message
        end
      end

      errors.to_hash[:base] || []
    end

    def condition_exists?(option_name)
      CONDITIONS.keys.include?(option_name.to_sym)
    end

    def condition_klass(option_name)
      CONDITIONS[option_name.to_sym]
    end

    extend self

  end

end
