# Retrieve games from https://www.mlb.com/scores

require_relative '../lib/mlb'

class MlbScores < Mlb

  STR_MATCH = {
    network_games: {
      facebook: 'MLB Live on Facebook Watch',
      mlbtv: 'Free Game of the Day'
    }
  }

  attr_reader :api

  def initialize
    @api = Api.new(
      'mlb_scores',
      'MLB Scores',
      'https://www.mlb.com/scores',
      'https://www.mlb.com'
    )

    super
  end

private
  
  def fetch_api
    api_uri = URI(@api.endpoint)
    res = watir(api_uri, '.mlb-scores__list-item--game')
    Nokogiri::HTML(res)
  rescue StandardError => error
    puts "\nERROR: #{error.message}\n\n#{error.inspect}\n\n#{error.backtrace}\n"
    nil
  end

  def parse_games(page)
    @games = nodes_game(page).map{ |node|
      game = Game.new()
      game.time = game_time(node)
      game.teams = parse_teams(nodes_team(node))
      game.href = game_href(node)
      game.free = game_free(node)

      if game.free
        if facebook_game_of_the_week(node)
          game.network = networks[:facebook]
        elsif mlb_game_of_the_day(node)
          game.network = networks[:mlbtv]
        end
      end

      game
    }
  end

  def parse_teams(nodes)
    nodes.map{ |node|
      team = Team.new()
      team.code = team_code(node)
      team.name = team_name(node)
      team.href = team_href(node)
      team
    }
  end

  def nodes_game(node)
    node.css('.mlb-scores--responsive .mlb-scores__list-item--game') rescue []
  end

  def nodes_team(node)
    node.css('.g5-component--mlb-scores__team') rescue []
  end
  
  def game_time(node)
    text = node.at_css('.g5-component--mlb-scores__linescore__gametime') rescue nil
    return nil if node.nil?
    text_date = scan_time(node.text)
    return nil if text_date.nil?
    Time.zone.parse(text_date)
  end

  def game_free(node)
    mlb_game_of_the_day(node) || facebook_game_of_the_week(node)
  end

  def game_href(node)
    href = node.at_css('.p-button--scores-preview > a').attr('href') rescue ''
    href.empty? ? '' : "#{api.base}#{href}"
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

  def mlb_game_of_the_day(node)
    text = node.at_css('.g5-component--mlb-scores__linescore__game-note').text.strip rescue ''
    !(text =~ /#{STR_MATCH[:network_games][:mlbtv]}/i).nil?
  end

  def facebook_game_of_the_week(node)
    !node.at_css('.p-button--scores-fgow').nil?
  end

end

