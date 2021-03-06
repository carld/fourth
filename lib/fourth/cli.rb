require 'thor'
require 'httparty'
require 'ostruct'
require 'erb'
require 'csv'
require 'json'
require 'time'

require 'fourth/query'

module Fourth

  class CLI < Thor
    include HTTParty

    base_uri 'https://minutedock.com/api/v1/'

    class_option :account_id, :type => :string
    class_option :headers, :type => :boolean, :default => :true
    class_option :debug, :type => :boolean

    class_option :from_date, :type => :string

    desc 'status', 'returns the current entry status'
    method_option :filter, :type => :array, :aliases => '-f', :desc => 'filter'
    def status
      data = Query.new(options).status
      data = data.parsed_response
      data = data.select {|k,v| options[:filter].include? k } if options[:filter]
      out = ERB.new <<-EOF.gsub(/^\s+/, '')
        Minute Doc Status
        -----------------
        Description: <%= data['description'] %>
        Duration:    <%= data['duration'] %>
        Logged:      <%= data['logged'] %>
      EOF
      puts out.result(binding)
    end

    desc 'log', 'log the current entry'
    def log
      res = Query.new(options).log
      tsv(res)
    end

    desc 'entries', 'return entries'
    def entries
      opts = {}
      opts[:query] = { 'from' => options["from_date"] } if options["from_date"]
      res = Query.new(options).entries(opts)
      tsv(res)
    end

    desc 'contacts', 'list contacts'
    def contacts
      res = Query.new(options).contacts
      tsv(res)
    end

    desc 'projects', 'list projects'
    def projects
      res = Query.new(options).projects
      tsv(res)
    end

    desc 'accounts', 'list accounts'
    def accounts
      res = Query.new(options).accounts
      tsv(res)
    end

    desc 'tasks', 'list tasks'
    def tasks
      res = Query.new(options).tasks
      tsv(res)
    end


    option :from, :required => true
    option :to, :required => true
    option :project_id, :required => true
    desc 'copy', 'copy current entries from one account to the other, setting the project id on the destination'
    def copy
      q = {}
      q[:query] = { 'from' => options["from_date"] } if options["from_date"]

      opts = {:account_id => options[:to]}
      res = Query.new(opts).entries(q)
      dst = JSON.parse(res.body)

      opts = {:account_id => options[:from]}
      res = Query.new(opts).entries(q)
      src = JSON.parse(res.body)

      src.each do |entry|
        found = dst.select do |json|
          (json['description'] == entry['description']) &&
          (json['duration'] == entry['duration']) &&
          (json['logged_at'] = entry['logged_at'])
        end

        if found.length == 0
          puts "Copying '#{entry['description']}'"
          opts = {:account_id => options[:to]}
          body = {}
          body['entry[description]'] = entry['description']
          body['entry[duration]'] = entry['duration']
          body['entry[project_id]'] = options[:project_id]
          body['entry[log_at]']    = entry['log_at'] || entry['logged_at']
          body['entry[logged_at]'] = entry['log_at'] || entry['logged_at']
          res = Query.new(opts).entry({body: body})
        else
          puts "Skipping #{found.length} duplicate '#{entry['description']}'"
        end
      end
    end

    private

    def tsv(response)
      puts options.inspect if options[:debug]
      json = JSON.parse(response.body)
      puts json.first.collect {|k,v| k}.join("\t") if options[:headers]
      puts json.collect {|node| node.collect{|k,v| v || "nil" }.join("\t") }.join("\n")
    end
  end

end
