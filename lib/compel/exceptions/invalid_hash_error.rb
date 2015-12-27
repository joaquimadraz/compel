module Compel

  class InvalidHashError < StandardError

    attr_accessor :object, :errors

  end

end
