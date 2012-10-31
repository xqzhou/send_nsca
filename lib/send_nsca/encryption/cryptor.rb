module SendNsca

  module Encryption

    class Cryptor

      PACKET_VERSION = 3
      PACK_STRING = "nxx N a4 n a64 a128 a512xx"

      def initialize(method, options)
        @method = METHODS[method].new(options)
      end

      def encrypt(*data)
        string_to_send = package(data)
        @method.execute(string_to_send)
      end

      private
      def package(data)
        data_pack = data.unshift(PACKET_VERSION, 0)
        string_to_send_without_crc = data_pack.pack(PACK_STRING)

        crc = CRC32.crc32(string_to_send_without_crc)

        data_pack[1] = crc
        data_pack.pack(PACK_STRING)
      end

    end

    class CRC32

      def self.crc32(c)
        r = 0xFFFFFFFF
        c.each_byte do |b|
          r ^= b
          8.times do
            r = (r>>1) ^ (0xEDB88320 * (r & 1))
          end
        end
        r ^ 0xFFFFFFFF
      end

    end

  end

end