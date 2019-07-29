require 'awesome_print'
require 'lightly'
require 'watir'

module Mlb
  module ClientHelper

    def fetch(date=nil, tz='US/Eastern')
      set_time_zone(tz)
      date = Date.today unless date_valid?(date)
      uri_endpoint = URI(endpoint(date))
      response = watir(uri_endpoint, self.class::CSS_WAIT)
      Nokogiri::HTML(response)
    end

    def watir(uri, wait_css=nil)
      cache_key = File.join(uri.host.parameterize, uri.path.parameterize)
      lightly = Lightly.new(dir: "tmp/lightly", life: '1h')

      lightly.get(cache_key) do
        page = Watir::Browser.start(uri.to_s, :chrome, headless: true)
        page.element(css: wait_css).wait_until_present unless wait_css.nil?
        page.html
      end
    end

  end
end