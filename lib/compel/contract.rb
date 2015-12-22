module Compel

  class Contract

    attr_reader :errors,
                :conditions

    def initialize(params, &block)
      @errors = Errors.new
      @params = params
      @conditions = Hashie::Mash.new

      instance_eval(&block)
    end

    def validate
      complete_params.each do |param, value|
        begin
          # If it is an Hash and it was given conditions for that Hash,
          # build a new Compel::Contract form inner params
          if (@conditions[param][:type] == Hash && !@conditions[param][:conditions].nil?)
            # If this param is required, build the Compel::Contract,
            # otherwise, only build it if is given a valid hash
            if (!!@conditions[param][:options][:required] || (!@params[param.to_sym].nil? && Coercion.valid?(@params, Hash)))
              contract = Contract.new(@params[param.to_sym], &@conditions[param][:conditions]).validate
              errors.add(param, contract.errors)
            end
          end

          Coercion.coerce(value, @conditions[param][:type], @conditions[param][:options])

          errors.add(param, Validation.validate(value, @conditions[param][:options]))
        rescue Compel::InvalidParameterError => exception
          errors.add(param, exception.message)
        end
      end

      self
    end

    def param(name, type, options = {}, &block)
      @conditions[name] = Hashie::Mash.new(type: type, options: options, conditions: block)
    end

    def valid?
      @errors.empty?
    end

    def complete_params
      if @params.nil? || !Coercion.valid?(@params, Hash)
        raise InvalidParameterError, 'Compel params must be an Hash'
      end

      params = Hashie::Mash.new(@params)

      {}.tap do |h|
        @conditions.keys.each do |key|
          h[key] = params[key]
        end
      end
    end

  end

end
