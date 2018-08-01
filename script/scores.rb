require 'awesome_print'

require_relative '../lib/application_helper'
require_relative '../lib/mlb_scores'

include ApplicationHelper

report_file_run(__FILE__)

mlb = MlbScores.new
mlb.fetch_games

#ap mlb.games
#ap mlb.free_games

mlb.notify_free_games