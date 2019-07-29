require 'awesome_print'

module Mlb
  module ParserHelper

    RGX_DATE_TIME = /(\d{1,2}\:\d{1,2})\s+([a-zA-Z]{1,3})\s*([a-zA-Z]{1,3}){0,1}/

    def game_key(node)
      node.attr('data-gamepk') rescue nil
    end

    def game_href(key)
      File.join('https://www.mlb.com', 'gameday', key, 'preview')
    end
      
    def game_time(node, selector)
      text = node.at_css(selector) rescue nil
      return nil if node.nil?
      text_date = scan_time(node.text)
      return nil if text_date.nil?
      Time.zone.parse(text_date)
    end

    def scan_time(text)
      text = text.strip
      return nil if text.blank?
      scans = text.scan(RGX_DATE_TIME)
      return nil if scans.empty?
      #ap text
      #ap scans
      scans[0].join(" ")
    end

  end
end