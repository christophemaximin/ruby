require_relative '../../spec_helper'
require 'resolv'

describe "Resolv#getaddresses" do
  platform_is_not :windows do
    it "resolves localhost" do
      res = Resolv.new([Resolv::Hosts.new])

      addresses = res.getaddresses("localhost")
      addresses.should_not == nil
      addresses.size.should > 0
    end
  end
end

describe "Resolv.getaddresses" do
  it "calls DefaultResolver#getaddresses" do
    Resolv::DefaultResolver.should_receive(:getaddresses).with("localhost")
    Resolv.getaddresses("localhost")
  end

  ruby_version_is "2.6" do
    context "with a custom resolver" do
      after do
        Resolv.current_resolver = nil
      end

      it "calls #getaddresses on the custom resolver" do
        resolver = Resolv.new([])
        resolver.should_receive(:getaddresses).with("localhost")

        Resolv.current_resolver = resolver
        Resolv.getaddresses("localhost")
      end
    end
  end
end
