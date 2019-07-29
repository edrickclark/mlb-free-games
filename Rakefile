require 'awesome_print'

require './lib/helpers/application_helper'
# require './lib/mlb/clients/scores'
# require './lib/mlb/parsers/scores'
require './lib/mlb/clients/streams'
require './lib/mlb/parsers/streams'

namespace 'mlb' do

  desc "MLB Scores"
  task :streams, [:date] do |task, args|
    args.transform_values!(&:strip)
    date = Date.parse(args[:date]) rescue nil

    client = Mlb::Client::Streams.new
    data = client.fetch(date)

    parser = Mlb::Parser::Streams.new
    data = parser.parse(data)

    ap data
  end

end

