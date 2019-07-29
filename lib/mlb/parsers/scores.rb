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
    class Scores
      include ParserHelper

      STR_MATCH = {
        network_games: {
          facebook: 'MLB Live on Facebook Watch',
          youtube: 'Live on YouTube - Watch Free',
          mlbtv: 'Free Game of the Day'
        }
      }

      def initialize
        @networks = networks
      end

      def parse(data)
        nodes_game(data).map do |node|
          game = Game.new
          game.teams = parse_teams(nodes_team(node))
          game.stmp = game_time(node, '.g5-component--mlb-scores__linescore__gametime')
          game.network = game_network(node)
          game.href = game_href(node)
          game.free = game_free(node)

          if game.free
            if facebook_game_of_the_month(node)
              game.network = @networks[:facebook]
            elsif mlb_game_of_the_day(node)
              game.network = @networks[:mlbtv]
            end
          end

          game
        end
      end

    private

      def nodes_game(node)
        node.css('.mlb-scores--responsive .g5-component--mlb-scores__game-wrapper') rescue []
      end

      def nodes_team(node)
        node.css('.g5-component--mlb-scores__team') rescue []
      end

      def parse_teams(nodes)
        nodes.map do |node|
          team = Team.new
          team.code = team_code(node)
          team.name = team_name(node)
          team.href = team_href(node)
          team
        end
      end

      def game_free(node)
        facebook_game(node) ||
        youtube_game(node) ||
        mlbtv_game(node)
      end

      def game_network(node)
        if facebook_game(node)
          @networks[:facebook]
        elsif youtube_game(node)
          @networks[:youtube]
        else
          @networks[:mlbtv]
        end
      end

      def team_code(node)
        node.at_css('.g5-component--mlb-scores__team__info__name--abbrev').text.strip.downcase rescue ''
      end

      def team_name(node)
        node.at_css('.g5-component--mlb-scores__team__info__name--long').text.strip rescue ''
      end

      def team_href(node)
        node.at_css('.g5-component--mlb-scores__team__info > a').attr('href').strip rescue ''
      end

      # Network Checks

      def mlbtv_game(node)
        text = node.at_css('.g5-component--mlb-scores__linescore__game-note').text.strip rescue ''
        !(text =~ /#{STR_MATCH[:network_games][:mlbtv]}/i).nil?
      end

      def youtube_game(node)
        text = node.at_css('.g5-component--mlb-scores__linescore__game-note').text.strip rescue ''
        !(text =~ /#{STR_MATCH[:network_games][:youtube]}/i).nil?
      end

      def facebook_game(node)
        !node.at_css('.p-button--scores-fgow').nil?
      end
    
    end
  end
end
