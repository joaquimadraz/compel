module Compel

  class InvalidHashError < StandardError

    attr_accessor :params, :errors

  end

end
