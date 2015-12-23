module Compel

  class Errors

    def initialize
      @errors = Hashie::Mash.new
    end

    def add(key, error)
      if error.is_a?(Compel::Errors)
        if error.empty?
          return
        end

        if @errors[key].nil?
          @errors[key] = {}
        end

        @errors[key].merge!(error.to_hash)

        return
      end

      if !error.is_a?(Array)
        error = [error]
      end

      if error.empty?
        return
      end

      if @errors[key].nil?
        @errors[key] = []
      end

      @errors[key].concat(error)
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
