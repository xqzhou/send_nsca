module SendNsca

  module Encryption

    SIMPLE_XOR = :simple_xor

    METHODS = {
      :simple_xor => Methods::SimpleXOR
    }

  end

end