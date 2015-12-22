module Compel

  class Param

    attr_reader :name,
                :type,
                :options,
                :conditions

    def initialize(name, type, value, options = {}, &conditions)
      @name = name
      @type = type
      @value = value
      @options = options
      @conditions = conditions
    end

    def value
      default_value = if options[:default].is_a?(Proc)
        options[:default].call
      else
        options[:default]
      end

      @value || default_value
    end

    def value=(value)
      @value = value
    end

    def required?
      !!@options[:required]
    end

    def hash?
      @type == Hash
    end

    def conditions?
      !!@conditions
    end

  end

end
