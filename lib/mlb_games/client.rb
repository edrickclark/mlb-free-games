# FILE: lib/mlb_free_games.rb

require 'awesome_print'
require 'nokogiri'
require 'watir'
require 'json'
require 'time'
require 'uri'

require './lib/application_helper'

module MlbGames
  class Client

    include ApplicationHelper

    Stream = Struct.new(:label, :href, :region, :type)
    Network = Struct.new(:slug, :name, :href)
    Api = Struct.new(:slug, :name, :endpoint, :base, :css)
    Game = Struct.new(:key, :stmp, :teams, :free, :href, :network, :streams)
    Team = Struct.new(:slug, :code, :name, :href)
    Season = Struct.new(:start, :end, :current)

    attr_reader :networks, :games, :free_games

    def initialize
      set_time_zone('US/Eastern')

      @date = Date.today

      @networks = {
        mlbtv: Network.new(
          'mlbtv',
          'MLBTV',
          'https://www.mlb.com/live-stream-games'
        ),
        facebook: Network.new(
          'facebook',
          'Facebook',
          'https://www.facebook.com/MLBLiveGames'
        )
      }

      @seasons = [
        {
          start: Date.new(2018,2,19),
          end: Date.new(2018,10,30)
        }
      ]
    end

    def parse_free_games
      if @games.blank?
        puts '@games was blank' 
        @free_games = nil
        return nil
      end

      @free_games = @games.select{ |game| game.free }
    rescue MlbGames::Error => error
      puts "\nERROR: #{error.message}\n\n#{error.inspect}\n\n#{error.backtrace}\n"
    end

    def notify_free_games
      if @free_games.nil?
        puts '@free_games was nil'
        return nil
      elsif @free_games.empty?
        puts "Sorry, no free games today..."
        return nil
      end

      free_games_length = @free_games.length

      games_pluralized =  (free_games_length == 1) ? 'Game' : 'Game'.pluralize

      games_message = @free_games.each_with_index.map{ |game,i|
        msg_teams = game.teams.map{ |team| "#{team.name} (#{team.slug || team.code})" }.join(' vs ')

        game_message = "#{i+1}) #{msg_teams}"
        game_message += ", on #{game.network.name}" unless game.network.nil?
        game_message += ", #{stmp_str(game.stmp.in_time_zone('US/Pacific'),"%A %m/%d/%Y at %l:%M %p %Z").gsub(/\s+/,' ')}" unless game.stmp.nil?
        game_message += ", #{game.href}"

        game_message
      }.join("\n")

      title_message = "The following #{free_games_length} #{games_pluralized} #{free_games_length==1 ? 'is' : 'are'} available free #{}"
      title_message = underline(title_message)

      puts "\n#{title_message}\n\n#{games_message}\n\n"
    rescue MlbGames::Error => error
      puts "\nERROR: #{error.message}\n\n#{error.inspect}\n\n#{error.backtrace}\n"
      nil
    end

  #protected

    def fetch
      response = watir(api_uri, @api.css)
      @html = Nokogiri::HTML(response)
    rescue MlbGames::Error => error
      puts "\nERROR: #{error.message}\n\n#{error.inspect}\n\n#{error.backtrace}\n"
      nil
    end

  private

    def api_uri
      if @date.present?
        URI("#{@api.endpoint}/#{date_formatted}")
      else
        URI(@api.endpoint)
      end
    end

    def set_time_zone(tz)
      Time.zone = tz
    end

  end
end
