require_relative '../../spec_helper'
require 'resolv'

describe "Resolv#getaddress" do
  platform_is_not :windows do
    it "resolves localhost" do
      res = Resolv.new([Resolv::Hosts.new])

      lambda {
        res.getaddress("localhost")
      }.should_not raise_error(Resolv::ResolvError)
    end
  end

  it "raises ResolvError if the name can not be looked up" do
    res = Resolv.new([])
    lambda {
      res.getaddress("should.raise.error.")
    }.should raise_error(Resolv::ResolvError)
  end
end

describe "Resolv.getaddress" do
  it "calls DefaultResolver#getaddress" do
    Resolv::DefaultResolver.should_receive(:getaddress).with("localhost")
    Resolv.getaddress("localhost")
  end

  ruby_version_is "2.6" do
    context "with a custom resolver" do
      after do
        Resolv.current_resolver = nil
      end

      it "calls #getaddress on the custom resolver" do
        resolver = Resolv.new([])
        resolver.should_receive(:getaddress).with("localhost")

        Resolv.current_resolver = resolver
        Resolv.getaddress("localhost")
      end
    end
  end
end
