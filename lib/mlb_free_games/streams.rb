# FILE: lib/mlb_free_games/streams.rb

# Retrieve games from https://www.mlb.com/live-stream-games

require_relative '../mlb_free_games'

class Streams < MlbFreeGames

  attr_reader :api, :html
  attr_accessor :date

  def initialize
    @api = Api.new(
      'mlb_streams',
      'MLB Streams',
      'https://www.mlb.com/live-stream-games',
      'https://www.mlb.com',
      '#games-results'
    )

    super
  end

  def parse
    @games = nodes_game(@html).map{ |node|
      game = Game.new()
      game.key = game_key(node)
      game.stmp = game_time(node)
      game.teams = parse_teams(nodes_team(node))
      game.href = game_href(node)
      game.free = game_free(node)
      game.network = game_network(node)
      #game.streams = game_streams(node)
      game
    }
  end

  def date_formatted
    @date.strftime("%Y/%m/%d")
  end

private

  def parse_teams(nodes)
    nodes.map{ |node|
      team = Team.new()
      team.slug = team_slug(node)
      team.name = team_name(node)
      team
    }
  end

  def nodes_game(node)
    node.css('.card-container') rescue []
  end

  def nodes_team(node)
    node.css('.card-title-name') rescue []
  end
  
  def game_key(node)
    text = node.attr('data-gamepk').strip rescue ''
  end
  
  def game_time(node)
    node = node.at_css('> div.card-times') rescue nil
    return nil if node.nil?
    text_date = scan_time(node.text)
    return nil if text_date.nil?
    Time.zone.parse(text_date)
  end

  def game_free(node)
    !(node.attr('class').strip =~ /(free-game|facebook)/).nil?
  end

  def game_href(node)
    game_external_id = node.attr('data-gamepk') rescue nil
    game_external_id.nil? ? api.endpoint : "#{api.base}/gameday/#{game_external_id}/preview"
  end

  def game_network(node)
    node.attr('class').strip =~ /facebook/ ? @networks[:facebook] : @networks[:mlbtv]
  end

  def game_streams(node)
    streams = []

    node_video = node.at_css('.mlbtv-card-info')
    node_audio = node.at_css('.gdaudio-card-info')

    node_video.css('.card-info-feeds').each{ |node_stream|
      node_info = node_stream.at_css('> a')
      next if node_info.blank?
      streams << Stream.new(
        node_info.text.strip,
        node_info.attr('href').strip,
        parameterize(node_info.attr('data-title').strip.downcase),
        'video'
      )
    }

    node_audio.css('.card-info-feeds').each{ |node_stream|
      node_info = node_stream.at_css('> a')
      next if node_info.blank?
      streams << Stream.new(
        node_info.text.strip,
        node_info.attr('href').strip,
        parameterize(node_info.attr('data-title').strip.downcase),
        'audio'
      )
    }

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

