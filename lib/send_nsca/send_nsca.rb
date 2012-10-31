require 'socket'
require 'timeout'

module SendNsca

  STATUS_OK = 0
  STATUS_WARNING = 1
  STATUS_CRITICAL = 2

  class NscaConnection

    # params for connecting to the nsca/nagios server
    attr_accessor  :nscahost
    attr_accessor  :port

    #  connection status and error if one found
    attr_reader   :connected
    attr_reader   :error

    # status data to send to nagios
    # Currently all 4 are required, meaning we only support 'service' passive checkins. 
    # todo: add host checkins
    attr_accessor  :hostname
    attr_accessor  :service
    attr_accessor  :return_code
    attr_accessor  :status
    attr_accessor  :timeout_value

    def initialize(args)
      @nscahost = args[:nscahost]
      @port = args[:port]
      @hostname = args[:hostname]
      @service = args[:service]
      @return_code = args[:return_code]
      @status = args[:status]
      @timeout_value = args[:timeout] || 1
      @password = args[:password] || ''
      @methods = args[:methods] || SendNsca::Encryption::SIMPLE_XOR

      @connected = false
    end

    def send_nsca
      intialize_connection

      convertor = Encryption::Cryptor.new(@methods, :iv => iv, :password => @password)

      encrypted_string_to_send = convertor.encrypt(timestring, @return_code, @hostname, @service, @status)

      @tcp_client.send(encrypted_string_to_send, 0)
      @tcp_client.close
    end

    private

    def intialize_connection
      begin
        timeout(@timeout_value) do
          @tcp_client = TCPSocket.open(@nscahost, @port)
          @connected = true
          @iv_and_timestamp = @tcp_client.recv(132)
        end
      rescue
        @connected = false
        @error = "send_ncsa - error connecting to nsca/nagios: #{$!}"
        puts  @error
        raise
      end
    end

    def timestring
      @iv_and_timestamp[@iv_and_timestamp.length-4,@iv_and_timestamp.length]
    end

    def iv
      @iv_and_timestamp[0,@iv_and_timestamp.length-4]
    end

    def readable_timestamp
      iv_and_timestamp_str = @iv_and_timestamp.unpack("H*")
      timestring_for_log = iv_and_timestamp_str[0][256,8]
      timestamp_hex = timestring_for_log.hex
      Time.at(timestamp_hex)
    end

  end

end
