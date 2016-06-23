require 'thor'
require 'httparty'
require 'ostruct'
require 'erb'
require 'fourth/query'

module Fourth

  class CLI < Thor
    include HTTParty

    base_uri 'https://minutedock.com/api/v1/'

    desc 'status', 'returns the current entry status'
    method_option :filter, :type => :array, :aliases => '-f', :desc => 'filter'
    def status
      data = Query.new.status
      data = data.parsed_response
      data = data.select {|k,v| options[:filter].include? k } if options[:filter]
      out = ERB.new <<-EOF.gsub(/^\s+/, '')
        Minute Doc Status
        -----------------
        Description: <%= data['description'] %>
        Duration: <%= data['duration'] %>
        Logged: <%= data['logged'] %>
      EOF
      puts out.result(binding)
    end

    desc 'log', 'log the current entry'
    def log
      resp = Query.new.log
      puts resp.parsed_response
    end

    desc 'entries', 'return entries'
    def entries
      res = Query.new.entries
      puts res.parsed_response
    end

    desc 'entry', 'create a new entry'
    def entry(description)
      res = Query.new.entry(description)
      puts res.parsed_response
    end

    desc 'contacts', 'list contacts'
    def contacts
      res = Query.new.contacts
      puts res.parsed_response
    end

    desc 'projects', 'list projects'
    def projects
      res = Query.new.projects
      puts res.parsed_response
    end

    desc 'accounts', 'list accounts'
    def accounts
      res = Query.new.accounts
      puts res.parsed_response
    end
  end

end
