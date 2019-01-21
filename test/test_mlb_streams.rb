# File: test/test_mlb_streams.rb
# ===============================

require "minitest/autorun"
require 'mlb_streams'

describe 'MlbStreams' do
  
  mlb = MlbStreams.new

  describe 'Api' do

    it "has a slug" do
      expect(mlb.api.slug).to be_truthy
    end

    it "has a name" do
      expect(mlb.api.name).to be_truthy
    end

    it "has an endpoint" do
      expect(mlb.api.endpoint).to be_truthy
    end

  end

end