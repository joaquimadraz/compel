module Compel

  class Contract

    attr_reader :object, :schema


    def initialize(object, schema)
      @object = object
      @schema = schema
    end

    def validate
      validator = validator_klass.new(object, schema)
      validator.validate

      Result.new(validator)
    end

    def validator_klass
      validator_klass = if schema.type == Coercion::Hash
        if object.nil? || !Coercion.valid?(object, Hash)
          raise Compel::TypeError, 'must be an Hash'
        end

        Validators::HashValidator
      else
        Validators::TypeValidator
      end
    end

  end

end
