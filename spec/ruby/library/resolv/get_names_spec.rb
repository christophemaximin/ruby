require_relative '../../spec_helper'
require 'resolv'

describe "Resolv#getnames" do
  platform_is_not :windows do
    it "resolves 127.0.0.1" do
      res = Resolv.new([Resolv::Hosts.new])

      names = res.getnames("127.0.0.1")
      names.should_not == nil
      names.size.should > 0
    end
  end
end

describe "Resolv.getnames" do
  it "calls DefaultResolver#getnames" do
    Resolv::DefaultResolver.should_receive(:getnames).with("127.0.0.1")
    Resolv.getnames("127.0.0.1")
  end

  ruby_version_is "2.6" do
    context "with a custom resolver" do
      after do
        Resolv.current_resolver = nil
      end

      it "calls #getnames on the custom resolver" do
        resolver = Resolv.new([])
        resolver.should_receive(:getnames).with("127.0.0.1")

        Resolv.current_resolver = resolver
        Resolv.getnames("127.0.0.1")
      end
    end
  end
end
