require 'thor'
require 'httparty'
require 'ostruct'
require 'erb'
require 'csv'
require 'json'
require 'time'

require 'fourth/query'
require 'fourth/cli_copy'
require 'fourth/cli_multi'

module Fourth

  class CLI < Thor
    include HTTParty

    base_uri 'https://minutedock.com/api/v1/'

    class_option :account_id, :type => :string
    class_option :headers, :type => :boolean, :default => :true

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
      res = Query.new(options).entries
      tsv(res)
    end

    desc 'entry', 'create a new entry'
    def entry(description='',duration='',contact_id='',task_ids='')
      res = Query.new(options).entry(description,duration,contact_id,task_ids)
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

    desc 'submit', 'submit entries via stdin in tab delimited format'
    def submit
      res = Query.new(options).entries
      existing = JSON.parse(res.body)
      entries = CSV.new($stdin, { col_sep:"\t", row_sep:"\n", headers: options[:headers] } )
      entries.each do |row|
        found = existing.select do |json|
          (json['description'] == row['description']) && (json['duration'].to_s == row['duration'])
        end

        if found.length == 0
          puts "Submitting '#{row['description']}'"
          body = {}
          body['entry[description]'] = row['description']
          body['entry[duration]'] = row['duration']
          res = Query.new(options).entry({body: body})
        else
          puts "Skipping #{found.length} duplicate '#{row['description']}'"
        end
      end
      puts "Finished submission to #{options[:account_id]}"
    end

    private

    def tsv(response)
      json = JSON.parse(response.body)
      puts json.first.collect {|k,v| k}.join("\t") if options[:headers]
      puts json.collect {|node| node.collect{|k,v| v || "nil" }.join("\t") }.join("\n")
    end
  end

end
