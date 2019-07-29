require 'awesome_print'
require 'nokogiri'
require 'time'

require './lib/helpers/application_helper'

module Mlb
  class Stream

    attr_accessor :label, :href, :region, :type

  end
end
