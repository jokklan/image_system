# encoding: utf-8
require 'spec_helper'
require 'hash_utils'

describe HashUtils do

  describe ".to_url_params" do

    it "returns the empty string if no elements in the given hash" do
      res = HashUtils.to_url_params
      res.should eq("")
    end

    it "returns a string in the form of url params" do
      res = HashUtils.to_url_params({ andre: 1, johan: 2 })
      res.should include("andre=1")
      res.should include("johan=2")
    end

    it "returns a string in the form of url params without the nil values of the hash" do
      res = HashUtils.to_url_params({ andre: 1, johan: 2, rasmus: nil })
      res.should include("andre=1")
      res.should include("johan=2")
      res.should_not include("rasmus=")
    end
  end
end
