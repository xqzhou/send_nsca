require 'spec_helper'

describe "CRC32" do

  it "should create a valid crc" do

    #    Hello crc = 4157704578
    hello = "Hello"
    crc_hello = SendNsca::Encryption::CRC32.crc32(hello)
    crc_hello.should eql 4157704578

    #    world! crc = 2459426729
    world = " world!"
    hello_world_1 = SendNsca::Encryption::CRC32.crc32(world)
    hello_world_1.should eql 2459426729

    #    Hello World crc = 1243066710
    hello_world = "Hello World"
    hello_world_2 = SendNsca::Encryption::CRC32.crc32(hello_world)
    hello_world_2.should eql 1243066710
  end

end