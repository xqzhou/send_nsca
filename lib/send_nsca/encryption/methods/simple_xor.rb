module SendNsca

  module Encryption

    module Methods

      class SimpleXOR

        def initialize(options)
          @xor_key = options[:iv] || ''
          @password = options[:password] || ''
        end

        def execute(message)
          xor(@xor_key, message, @password)
        end

        private

        def xor(iv, str, password='')
          str_a = str.unpack("C*")
          iv_a = iv.unpack("C*")
          password_a = password.unpack("C*")
          result = []

          str_a.each_with_index do |c, i|
            result[i] = c ^ iv_a[i % iv_a.size]
            result[i] ^= password_a[i % password_a.size] unless password_a.empty?
          end

          ret_val = result.pack("C*")
        end

      end

    end

  end

end