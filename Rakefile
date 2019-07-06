require 'awesome_print'

require './lib/application_helper'
require './lib/mlb_games/scores'
require './lib/mlb_games/streams'

namespace 'mlb' do

  desc "MLB Streams"
  task :streams do |task, args|
    mlb = MlbGames::Streams.new
    mlb.fetch
    mlb.parse
    mlb.parse_free_games
    mlb.notify_free_games
  end

  desc "MLB Scores"
  task :scores do |task, args|
    mlb = MlbGames::Scores.new
    mlb.fetch
    mlb.parse
    mlb.parse_free_games
    mlb.notify_free_games
  end

end

