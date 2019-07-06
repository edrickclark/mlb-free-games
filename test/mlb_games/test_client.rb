# File: test/mlb_games/test_client.rb
# ====================================

require "minitest/autorun"

require './lib/mlb_games/client'

class MlbGames::ClientTest < Minitest::Test
  
  def test_attributes_are_accessible
    mlb = MlbGames::Client.new
    assert_respond_to(mlb, :networks)
    assert_respond_to(mlb, :games)
    assert_respond_to(mlb, :free_games)
  end

  def test_attribute_networks
    mlb = MlbGames::Client.new
    assert_kind_of(Hash, mlb.networks)
    assert_kind_of(MlbGames::Client::Network, mlb.networks[:mlbtv])
    assert_kind_of(MlbGames::Client::Network, mlb.networks[:facebook])
  end

end