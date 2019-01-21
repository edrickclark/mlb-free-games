# File: test/test_mlb.rb
# =======================

require "minitest/autorun"
require 'mlb'

describe 'Mlb' do
  
  mlb = Mlb.new

  describe 'attributes' do
    
    it "allows reading for networks" do
      expect(mlb).to respond_to(:networks)
    end

    it "allows reading for games" do
      expect(mlb).to respond_to(:games)
    end

    it "allows reading for free_games" do
      expect(mlb).to respond_to(:free_games)
    end

    it "allows reading for facebook_games" do
      expect(mlb).to respond_to(:facebook_games)
    end
  end
  
  describe 'networks' do

    it "returns a hash" do
      expect(mlb.networks).to be_a(Hash)
    end

    it "returns a hash of 'Mlb::Network' structs" do
      expect(mlb.networks[:mlbtv]).to be_a(Mlb::Network)
    end

    it "returns a hash of 'Mlb::Network' structs" do
      expect(mlb.networks[:facebook]).to be_a(Mlb::Network)
    end

  end

end