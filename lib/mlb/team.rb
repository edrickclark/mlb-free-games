require 'awesome_print'
require 'nokogiri'
require 'time'

require './lib/helpers/application_helper'

module Mlb
  class Team

    attr_accessor :slug, :code, :name, :href

  end
end
