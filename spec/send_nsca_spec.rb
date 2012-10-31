require 'spec_helper'

describe "SendNsca" do

  it "should correctly send a message to the server" do

    args = {
      :nscahost => "localhost",
      :port => 5667,
      :hostname => "kbedell",
      :service => "passive-checkin-test01" ,
      :return_code => SendNsca::STATUS_OK,
      :status => "TEST",
      :encryption => SendNsca::Encryption::SIMPLE_XOR
    }

    nsca_connection = SendNsca::NscaConnection.new(args)

    nsca_connection.send_nsca

  end

end
