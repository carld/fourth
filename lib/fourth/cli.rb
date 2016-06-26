require 'thor'
require 'httparty'
require 'ostruct'
require 'erb'
require 'csv'
require 'json'

require 'fourth/query'
require 'fourth/cli_copy'
require 'fourth/cli_multi'

module Fourth

  class CLI < Thor
    include HTTParty

    base_uri 'https://minutedock.com/api/v1/'

    class_option :account_id, :type => :string
    class_option :headers, :type => :boolean

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
      puts_response(res)
    end

    desc 'entries', 'return entries'
    def entries
      res = Query.new(options).entries
      puts_response(res)
    end

    desc 'entry', 'create a new entry'
    def entry(description)
      res = Query.new(options).entry(description)
      puts_response(res)
    end

    desc 'contacts', 'list contacts'
    def contacts
      res = Query.new(options).contacts
      puts_response(res)
    end

    desc 'projects', 'list projects'
    def projects
      res = Query.new(options).projects
      puts_response(res)
    end

    desc 'accounts', 'list accounts'
    def accounts
      res = Query.new(options).accounts
      puts_response(res)
    end

    desc 'copy', 'copy entries from one account to another'
    subcommand 'copy', Copy

    desc 'multi', 'perform action on multiple accounts'
    subcommand 'multi', Multi

    private

    def puts_response(response)
      puts response.parsed_response.first.keys.join("\t") if options[:headers]
      response.parsed_response.each do |json|
        puts json.values.join("\t")
      end
    end
  end

end
