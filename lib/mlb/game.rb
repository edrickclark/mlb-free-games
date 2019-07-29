require 'awesome_print'
require 'nokogiri'
require 'time'

require './lib/helpers/application_helper'

module Mlb
  class Game

    attr_accessor :key, :stmp, :teams, :free, :href, :network, :streams

    STATUSES = [
      'live',
      'upcoming',
      'archive'
    ].freeze

  end
end
