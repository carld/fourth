require 'thor'
require 'httparty'
require 'ostruct'
require 'erb'
require 'fourth/query'

module Fourth

  class CLI < Thor
    include HTTParty

    base_uri 'https://minutedock.com/api/v1/'

    class_option :account_id, :type => :string


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
      res = Query.new(options).log
      puts res.parsed_response
    end

    desc 'entries', 'return entries'
    def entries
      res = Query.new(options).entries
      puts res.parsed_response
    end

    desc 'entry', 'create a new entry'
    def entry(description)
      res = Query.new(options).entry(description)
      puts res.parsed_response
    end

    desc 'contacts', 'list contacts'
    def contacts
      res = Query.new(options).contacts
      puts res.parsed_response
    end

    desc 'projects', 'list projects'
    def projects
      res = Query.new(options).projects
      puts res.parsed_response
    end

    desc 'accounts', 'list accounts'
    def accounts
      res = Query.new(options).accounts
      puts res.parsed_response
    end
  end

end
