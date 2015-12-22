module Compel

  class Contract

    attr_reader :errors,
                :conditions

    def initialize(params, &block)
      @errors = Errors.new
      @params = (params && Hashie::Mash.new(params)) rescue nil
      @conditions = Hashie::Mash.new

      instance_eval(&block)
    end

    def validate
      param_type = nil
      param_required = nil
      param_conditions = nil

      complete_params.each do |param, value|
        param_type = @conditions[param][:type]
        param_required = !!@conditions[param][:options][:required]
        param_conditions = @conditions[param][:conditions]

        begin
          # If it is an Hash and it was given conditions for that Hash,
          # build a new Compel::Contract form inner params
          if (param_type == Hash && !param_conditions.nil?)

            # If this param is required, build the Compel::Contract,
            # otherwise, only build it if is given a valid hash
            if param_required || (!@params[param].nil? && @params[param].is_a?(Hash))
              contract = \
                Contract.new(@params[param], &param_conditions).validate

              errors.add(param, contract.errors)
            end
          end

          # All values must coerce before going through validation
          Coercion.coerce! \
            value, param_type, @conditions[param][:options]

          #
          errors.add \
            param, Validation.validate(value, @conditions[param][:options])

        rescue Compel::InvalidParameterError => exception
          errors.add(param, exception.message)
        end
      end

      self
    end

    def param(name, type, options = {}, &block)
      @conditions[name] = { type: type, options: options, conditions: block }
    end

    def valid?
      @errors.empty?
    end

    def complete_params
      if @params.nil? || !Coercion.valid?(@params, Hash)
        raise InvalidParameterError, 'Compel params must be an Hash'
      end

      complete_params = {}.tap do |h|
        @conditions.keys.each do |key|
          h[key] = @params[key]
        end
      end

      Hashie::Mash.new(complete_params)
    end

  end

end
