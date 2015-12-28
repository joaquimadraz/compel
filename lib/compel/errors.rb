module Compel

  class Errors

    def initialize
      @errors = Hashie::Mash.new
    end

    def add(key, error)
      if error.empty?
        return
      end

      if error.is_a?(Compel::Errors) || error.is_a?(Hash)
        if @errors[key].nil?
          @errors[key] = {}
        end

        @errors[key].merge!(error.to_hash)
      else
        if @errors[key].nil?
          @errors[key] = []
        end

        if !error.is_a?(Array)
          error = [error]
        end

        @errors[key].concat(error)
      end

      @errors
    end

    def length
      @errors.keys.length
    end

    def empty?
      length == 0
    end

    def to_hash
      @errors
    end

  end

end
