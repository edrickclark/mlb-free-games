# File: test/mlb_games/test_scores.rb
# ====================================

require "minitest/autorun"

require './lib/mlb_games/scores'

class MlbGames::ScoresTest < Minitest::Test

  def test_attributes_are_accessible
    mlb = MlbGames::Scores.new
    assert_respond_to(mlb, :api)
    assert_respond_to(mlb, :html)
    assert_respond_to(mlb, :date)
  end

  def test_api_return_values
    mlb = MlbGames::Scores.new
    assert mlb.api.slug
    assert mlb.api.name
    assert mlb.api.endpoint
  end

end