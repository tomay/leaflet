require 'rspec'
require_relative '../rgb_to_hex'

describe RgbToHex, "#convert" do
  it "returns correct value" do
    rgb = RgbToHex.new(0,255,128)
    rgb.convert.should eq("#00FF80")
  end
  it "returns correct value" do
    rgb = RgbToHex.new(0,39,235)
    rgb.convert.should eq("#0027EB")
  end
  it "returns correct value" do
    rgb = RgbToHex.new(0,58,225)
    rgb.convert.should eq("#003AE1")
  end
  it "returns correct value" do
    rgb = RgbToHex.new(0,78,215)
    rgb.convert.should eq("#004ED7")
  end
  it "returns correct value" do
    rgb = RgbToHex.new(0,98,206)
    rgb.convert.should eq("#0062CE")
  end
  it "returns correct value" do
    rgb = RgbToHex.new(0,117,196)
    rgb.convert.should eq("#0075C4")
  end
  it "returns correct value" do
    rgb = RgbToHex.new(0,156,176)
    rgb.convert.should eq("#009CB0")
  end
  it "returns correct value" do
    rgb = RgbToHex.new(0,176,167)
    rgb.convert.should eq("#00B0A7")
  end
  it "returns correct value" do
    rgb = RgbToHex.new(0,196,157)
    rgb.convert.should eq("#00C49D")
  end
  it "returns correct value" do
    rgb = RgbToHex.new(0,235,137)
    rgb.convert.should eq("#00EB89")
  end
  it "returns correct value" do
    rgb = RgbToHex.new(0,19,245)
    rgb.convert.should eq("#0013F5")
  end
  it "returns correct value" do
    rgb = RgbToHex.new(0,0,255)
    rgb.convert.should eq("#0000FF")
  end
end
