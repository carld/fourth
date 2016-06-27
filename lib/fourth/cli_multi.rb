require 'thor'
require 'httparty'
require 'ostruct'
require 'erb'
require 'fourth/query'

module Fourth

  class Multi < Thor
    include HTTParty

    base_uri 'https://minutedock.com/api/v1/'

    class_option :account_ids, :type => :array

    desc "enter <description> <duration> <contact> <task>", "make entry against multiple accounts"
    def enter(description,duration=nil,contact_id=nil,task_ids=nil)
      puts options[:account_ids].inspect
      raise "multiple account ids not provided" if options[:account_ids].length < 2
      raise "stopping"
      options[:account_ids].each do |id|
        res = Query.new(options).entry(description,duration,contact_id,task_ids)
        puts_response(res)
      end
    end

    private

    def puts_response(response)
      puts response.parsed_response.first.keys.join("\t") if options[:headers]
      response.parsed_response.each do |json|
        puts json.values.join("\t")
      end
    end

  end
end
