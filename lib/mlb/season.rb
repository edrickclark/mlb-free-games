require 'awesome_print'
require 'nokogiri'
require 'time'

require './lib/helpers/application_helper'

module Mlb
  class Season

    attr_accessor :start, :end, :current

  end
end
