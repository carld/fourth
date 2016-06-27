require 'thor'
require 'httparty'
require 'ostruct'
require 'erb'
require 'time'
require 'fourth/query'

module Fourth

  class Copy < Thor
    include HTTParty

    base_uri 'https://minutedock.com/api/v1/'

    class_option :force, :type => :boolean

    desc "current_entries", "copy a set of entries from one account to another"
    def current_entries(from,to)
      options[:account_id] = from
      src = Query.new(options).entries
      puts src.parsed_response
      options[:account_id] = to
      dst = Query.new(options).entries
      puts dst.parsed_response

      src.sort { |a,b| format_time(a[:logged_at]) <=> format_time(b[:logged_at]) }
      dst.sort { |a,b| format_time(a[:logged_at]) <=> format_time(b[:logged_at]) }

      src.each do |k,v|
        
      end

    end

    {"id"=>5634881, "duration"=>1428, "contact_id"=>33992, "account_id"=>1869, "description"=>"communicating with Rackspace on secure deletion to give go ahead for high assurance disk wipe", "updated_at"=>"2016-06-20T17:16:20.000+12:00", "invoice_id"=>nil, "logged_at"=>"2016-06-20T09:50:29.000+12:00", "log_at"=>nil, "project_id"=>35488, "user_account_id"=>29079, "user_id"=>25961, "logged"=>true, "timer_active"=>false, "task_ids"=>[]}


    private
    def format_time(time)
      Time.iso8601(time).strftime('%Y-%m-%d %H:%M')
    end

  end
end
