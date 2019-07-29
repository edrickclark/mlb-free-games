require 'awesome_print'

# https://guides.rubyonrails.org/active_support_core_extensions.html

require 'active_support'
require 'active_support/core_ext/time/zones'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/inflections'

module ApplicationHelper

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

  def underline(str='',character='-')
    return '' if str.blank?
    "#{str}\n#{character * str.length}"
  end

end