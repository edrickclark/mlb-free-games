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
    return nil if blank(text)
    scans = text.scan(RGX_DATE_TIME)
    return nil if scans.empty?
    #ap text
    #ap scans
    scans[0].join(" ")
  end

  def underline(str='',character='-')
    return '' if blank(str)
    "#{str}\n#{character * str.length}"
  end

#=begin REPLACE WITH RAILS STUFFS
  def blank(x)
    if x.respond_to?(:strip!)
      x.strip!
    end
    x.nil? || x.empty?
  end

  def present(x)
    !blank(x)
  end

  def parameterize(s)
    #https://apidock.com/rails/ActiveSupport/Inflector/parameterize
    s.downcase.gsub(/[^0-9a-z]+/,'-')
  end

  def pluralize(term='thing',count=2)
    require 'plural'
  	count>1 ? term.plural : term
  end

  def englist(a=[])
    #https://stackoverflow.com/questions/2038787/join-array-contents-into-an-english-list
    case a.length
      when 0
        ""
      when 1
        a[0].to_s.dup
      when 2
        "#{a[0]} and #{a[1]}"
      else
        "#{a[0..-2].join(', ')}, and #{a[-1]}"
    end
  end
#=end

  def watir(uri,wait_for_css_node=nil)
    page = Watir::Browser.start(uri.to_s,:chrome,headless:true)
    page.element(css: wait_for_css_node).wait_until_present unless wait_for_css_node.nil?
    page.html
  rescue StandardError => error
    puts "\nERROR: #{error.message}\n\n#{error.inspect}\n\n#{error.backtrace}\n"
    nil
  end

  def http_request(uri=nil,body=nil,headers={},post=false)
    # THIS SHOULD BE A CLASS...

    require 'net/http'
    require 'net/https'

    raise "uri was nil" if uri.nil?
    
    puts "Requesting '#{uri.to_s}'"

    http = Net::HTTP.new(uri.host, uri.port)

    if uri.scheme == 'https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    request = post ? Net::HTTP::Post.new(uri.to_s) : Net::HTTP::Get.new(uri.to_s)
    
    headers.each{ |k,v| request.add_field k, v }

    request.body = body unless body.nil?

    response = http.request(request)

    unless response.code == '200'
      puts "\n\nResponse HTTP Status Code: #{response.code}\n\n"
      puts "\n\nResponse HTTP Response Body: #{response.body}\n\n"
    end

    response
  rescue StandardError => e
    puts "HTTP Request failed (#{e.message})"
  end

end