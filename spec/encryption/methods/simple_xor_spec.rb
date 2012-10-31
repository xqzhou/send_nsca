require 'spec_helper'

describe "Simple_XOR" do

  it "for simple string" do
    xor_key = "\377\376\375"
    str = "Hello!"

    simple_xor = SendNsca::Encryption::Methods::SimpleXOR.new(:iv => xor_key)

    encrypted_str = simple_xor.execute(str)
    deencrypted_str = simple_xor.execute(encrypted_str)
    deencrypted_str.should eql str

  end

  it "for complex xor key" do
    xor_key = "adsfkahudsflihasdflkahdsfoaiudfh-3284rqiuy8rtq49087ty  2-\123\666\001\004\377"
    str = "Hey There This is awesome!!!\000!"

    simple_xor = SendNsca::Encryption::Methods::SimpleXOR.new(:iv => xor_key)

    encrypted_str = simple_xor.execute(str)
    deencrypted_str = simple_xor.execute(encrypted_str)
    deencrypted_str.should eql str
  end

  it "for encoded string" do
    xor_key = "\377\376\375"
    str = "\000\000\000\000\111\222\333\123\321"

    simple_xor = SendNsca::Encryption::Methods::SimpleXOR.new(:iv => xor_key)

    encrypted_str = simple_xor.execute(str)
    deencrypted_str = simple_xor.execute(encrypted_str)
    deencrypted_str.should eql str
  end

  it "with password" do
    xor_key = "\377\376\375"
    str = "\000\000\000\000\111\222\333\123\321"

    simple_xor = SendNsca::Encryption::Methods::SimpleXOR.new(:iv => xor_key,
      :password => "YOURPASSWORD")

    encrypted_str = simple_xor.execute(str)
    deencrypted_str = simple_xor.execute(encrypted_str)
    deencrypted_str.should eql str
  end

end