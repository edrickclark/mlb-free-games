require 'active_support/time'
require 'awesome_print'
require 'nokogiri'
require 'watir'
require 'json'
require 'time'
require 'uri'

require_relative 'application_helper'

class Mlb

  include ApplicationHelper

  Stream = Struct.new(:label, :href, :region, :type)
  Network = Struct.new(:slug, :name)
  Api = Struct.new(:slug, :name, :endpoint, :base)
  Game = Struct.new(:key, :time, :teams, :free, :href, :network, :streams)
  Team = Struct.new(:slug, :code, :name, :href)

  attr_reader :networks, :games, :free_games, :facebook_games

  def initialize
    set_time_zone('US/Eastern')

    @networks = {
      mlbtv: Network.new(
        'mlbtv',
        'MLB.tv'
      ),
      facebook: Network.new(
        'facebook',
        'Facebook'
      )
    }
  end

  def fetch_games
    page = fetch_api
    parse_games(page)
    parse_free_games
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

    games_pluralized = pluralize('Game',free_games_length)


    games_message = @free_games.each_with_index.map{ |game,i|
      msg_teams = game.teams.map{ |team| "#{team.name} (#{team.slug || team.code})" }.join(' vs ')

      game_message = "#{i+1}) #{msg_teams}"
      game_message += ", on #{game.network.name}" unless game.network.nil?
      game_message += ", #{stmp_str(game.time.in_time_zone('US/Pacific'),"%A %m/%d/%Y at %l:%M %p %Z").gsub(/\s+/,' ')}" unless game.time.nil?
      game_message += ", #{game.href}" if present(game.href)

      game_message
    }.join("\n")

    title_message = "The following #{free_games_length} #{games_pluralized} #{free_games_length==1 ? 'is' : 'are'} available free today"
    title_message = underline(title_message)

    puts "\n#{title_message}\n\n#{games_message}\n\n"
  rescue StandardError => error
    puts "\nERROR: #{error.message}\n\n#{error.inspect}\n\n#{error.backtrace}\n"
    nil
  end

protected

  def parse_free_games
    if blank(@games)
      puts '@games was blank' 
      @free_games = nil
      return nil
    end

    @free_games = @games.select{ |game| game.free }
  rescue StandardError => error
    puts "\nERROR: #{error.message}\n\n#{error.inspect}\n\n#{error.backtrace}\n"
  end

private

  def set_time_zone(tz)
    Time.zone = tz
  end

end

