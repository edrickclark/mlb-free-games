require 'awesome_print'
require 'nokogiri'
require 'time'
require 'uri'

require './lib/helpers/application_helper'
require './lib/mlb/helpers/client_helper'

module Mlb
  module Client
    class Streams
      include ClientHelper

      ENDPOINT = 'https://www.mlb.com/live-stream-games'.freeze
      CSS_WAIT = '#games-results'.freeze

    private

      def endpoint(date)
        File.join(ENDPOINT, date_formatted(date))
      end

      def date_formatted(date)
        date.strftime("%Y/%m/%d")
      end

      def date_valid?(date)
        date.kind_of? Date
      end

      def set_time_zone(tz)
        Time.zone = tz
      end
    
    end
  end
end
