require 'awesome_print'
require 'nokogiri'
require 'time'

require './lib/helpers/application_helper'

module Mlb
  class Network

    attr_accessor :slug, :name, :href

    def self.generate
      mlbtv = Network.new
      mlbtv.slug = 'mlbtv'
      mlbtv.name = 'MLBTV'
      mlbtv.href = 'https://www.mlb.com/live-stream-games'
      
      facebook = Network.new
      facebook.slug = 'facebook'
      facebook.name = 'Facebook'
      facebook.href = 'https://www.facebook.com/MLBLiveGames'
      
      youtube = Network.new
      youtube.slug = 'youtube'
      youtube.name = 'YouTube'
      youtube.href = 'https://www.youtube.com/user/MLB'

      {
        mlbtv: mlbtv,
        facebook: facebook,
        youtube: youtube
      }
    end

  end
end
