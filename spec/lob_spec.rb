require "spec_helper"

describe Lob do
  it "should return the resource object for the valid version" do
    Lob(api_key: "test", api_version: "v1").must_be_kind_of(Lob::V1::Resource)
  end

  it "should raise an error if the version doesn't exist" do
    ->{Lob(api_key: "test", api_version: "test")}.must_raise(Lob::VersionInvalidError)
  end

  it "should raise an error if API key is not passed as an option or set on module" do
    Lob.api_key = nil  # make sure API key is nil
    ->{ Lob() }.must_raise(ArgumentError)
  end

  it "should *not* raise an error if API key has been on module and not passed as option" do
    Lob.api_key = "test"
    Lob().wont_be_nil
  end

  it "should pass the API key to the resource for the version" do
    Lob(api_key: "test").options[:api_key].must_equal "test"
  end

  it "should allow detailed configuration" do
    Lob.configure do |config|
      config.api_key = "test"
      config.api_version = "v1"
      config.protocol = "https"
      config.api_host = "api.lob.com"
    end

    Lob.api_key.must_equal "test"
    Lob.api_version.must_equal "v1"
    Lob.protocol.must_equal "https"
    Lob.api_host.must_equal "api.lob.com"
  end

  it "should work with Lob.load" do
    Lob.load(api_key: "test").options[:api_key].must_equal "test"

    Lob.api_key = "test"
    Lob.load.wont_be_nil

    Lob.api_key = nil  # make sure API key is nil
    ->{ Lob.load }.must_raise(ArgumentError)

    ->{Lob.load(api_key: "test", api_version: "test")}.must_raise(Lob::VersionInvalidError)

    Lob.load(api_key: "test", api_version: "v1").must_be_kind_of(Lob::V1::Resource)
  end
end
