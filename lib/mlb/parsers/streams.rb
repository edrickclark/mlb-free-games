require 'awesome_print'
require 'nokogiri'
require 'time'
require 'uri'

require './lib/helpers/application_helper'
require './lib/mlb/helpers/parser_helper'

require './lib/mlb/game'
require './lib/mlb/network'
require './lib/mlb/season'
require './lib/mlb/stream'
require './lib/mlb/team'

module Mlb
  module Parser
    class Streams
      include ParserHelper

      def initialize
        @networks = Network.generate
      end

      def parse(data)
        nodes_game(data).map do |node|
          game = Game.new
          game.key = game_key(node)
          game.href = game_href(game.key)
          game.teams = parse_teams(nodes_team(node))
          game.network = game_network(node)
          game.streams = game_streams(node)
          game.stmp = game_time(node, '> div.card-times')
          game.free = game_free(node)
          game
        end
      end

    private

      def nodes_game(node)
        node.css('.card-container')
      end

      def nodes_team(node)
        node.css('.card-title-name')
      end

      def parse_teams(nodes)
        nodes.map do |node|
          team = Team.new
          team.name = team_name(node)
          team.href = team_href(node)
          team
        end
      end
      
      def game_key(node)
        text = node.attr('data-gamepk').strip rescue ''
      end

      def game_free(node)
        classname = node.attr('class').strip
        !(classname =~ /(free-game|facebook|youtube)/).nil?
      end

      def game_network(node)
        classname = node.attr('class').strip
        if !(classname =~ /facebook/).nil?
          @networks[:facebook]
        elsif !(classname =~ /youtube/).nil?
          @networks[:youtube]
        else
          @networks[:mlbtv]
        end
      end

      def game_streams(node)
        streams = []

        node_video = node.at_css('.mlbtv-card-info')
        node_audio = node.at_css('.gdaudio-card-info')

        unless node_video.nil?
          node_video.css('.card-info-feeds').each do |node_stream|
            node_info = node_stream.at_css('> a')
            next if node_info.blank?

            streams << Stream.new(
              node_info.text.strip,
              node_info.attr('href').strip,
              parameterize(node_info.attr('data-title').strip.downcase),
              'video'
            )
          end
        end

        unless node_audio.nil?
          node_audio.css('.card-info-feeds').each do |node_stream|
            node_info = node_stream.at_css('> a')
            next if node_info.blank?

            streams << Stream.new(
              node_info.text.strip,
              node_info.attr('href').strip,
              parameterize(node_info.attr('data-title').strip.downcase),
              'audio'
            )
          end
        end

        streams
      end

      def team_slug(node)
        node.text.strip.downcase rescue ''
      end

      def team_name(node)
        node.text.strip rescue ''
      end

      def team_href(node)
        nil
      end
    
    end
  end
end
