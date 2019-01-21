require 'awesome_print'

# https://guides.rubyonrails.org/active_support_core_extensions.html

require 'active_support'
require 'active_support/core_ext/time/zones'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/inflections'

require './mlb_free_games/errors'

module ApplicationHelper

  RGX_DATE_TIME = /(\d{1,2}\:\d{1,2})\s+([a-zA-Z]{1,3})\s*([a-zA-Z]{1,3}){0,1}/

  def dotenvload
    require 'dotenv'
    Dotenv.load
  end

  def stmp_str(stmp=nil,fmt=nil)
    fmt = "%m/%d/%Y %H:%M:%S" if fmt.nil?
    stmp = Time.now if stmp.nil?
    stmp.strftime(fmt)
  end

  def report_file_run(filepath=nil,message=nil)
    return if filepath.nil?
    puts "\n\n#{stmp_str}\n#{filepath}\n\n"
    puts "#{message}\n\n" unless message.nil?
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

  def underline(str='',character='-')
    return '' if str.blank?
    "#{str}\n#{character * str.length}"
  end

  def watir(uri,wait_for_css_node=nil)
    page = Watir::Browser.start(uri.to_s,:chrome,headless:true)
    page.element(css: wait_for_css_node).wait_until_present unless wait_for_css_node.nil?
    page.html
  rescue MlbFreeGamesError => error
    puts "\nERROR: #{error.message}\n\n#{error.inspect}\n\n#{error.backtrace}\n"
    nil
  end

end