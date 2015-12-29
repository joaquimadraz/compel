module Compel

  class Contract

    attr_reader :object, :schema

    def initialize(object, schema)
      @object = object
      @schema = schema
    end

    def validate
      Result.new(setup!.validate)
    end

    private

    def setup!
      validator_klass.new(object, schema)
    end

    def validator_klass
      if schema.type == Coercion::Hash
        Validators::HashValidator
      elsif schema.type == Coercion::Array
        Validators::ArrayValidator
      else
        Validators::TypeValidator
      end
    end

  end

end
