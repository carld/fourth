require 'httparty'
require 'logger'

module Fourth

  class Query
    include HTTParty

    logger ::Logger.new 'httparty_debug.log', :debug, :curl

    base_uri 'https://minutedock.com/api/v1/'

    def post(path, options={})
      body = options[:body] ||= {}
      body['api_key'] = @api_key
      body['account_id'] = @account_id
      self.class.send(__method__, path, options)
    end

    def get(path, options={})
      query = options[:query] ||= {}
      query['api_key'] = @api_key
      query['account_id'] = @account_id
      self.class.send(__method__, path, options)
    end

    def endpoint(name, method, path='/', options={}, &block)
      Query.instance_eval do 
        define_method(name) do |options={}|
          self.send(method, path, options)
        end
      end
    end

    def initialize(options)
      @api_key = options[:api_key] || API_KEY
      @account_id = options[:account_id]

      endpoint(:status, :get, '/entries/current.json')
      endpoint(:log, :post, '/entries/current/log.json')
      endpoint(:entries, :get, '/entries.json')
      endpoint(:contacts, :get, '/contacts.json')
      endpoint(:projects, :get, '/projects.json')
      endpoint(:accounts, :get, '/accounts.json')
      endpoint(:tasks, :get, '/tasks.json')
      endpoint(:entry, :post, '/entries.json')
    end

  end
end
