# File: test/mlb_games/test_streams.rb
# =====================================

require "minitest/autorun"

require './lib/mlb_games/streams'

class MlbGames::ScoresTest < Minitest::Test

  def test_attributes_are_accessible
    mlb = MlbGames::Streams.new
    assert_respond_to(mlb, :api)
    assert_respond_to(mlb, :html)
    assert_respond_to(mlb, :date)
  end

  def test_api_return_values
    mlb = MlbGames::Streams.new
    assert mlb.api.slug
    assert mlb.api.name
    assert mlb.api.endpoint
  end

end