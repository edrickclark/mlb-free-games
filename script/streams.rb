require 'awesome_print'

require_relative '../lib/application_helper'
require_relative '../lib/mlb_streams'

include ApplicationHelper

report_file_run(__FILE__)

mlb = MlbStreams.new
mlb.fetch_games

#ap mlb.games
#ap mlb.free_games

mlb.notify_free_games