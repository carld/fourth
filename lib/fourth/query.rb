require 'httparty'
require 'logger'

module Fourth

  class Query
    include HTTParty

    logger ::Logger.new 'httparty_debug.log', :debug, :curl

    base_uri 'https://minutedock.com/api/v1/'

    def post(path, options)
      body = {}
      body['api_key'] = @api_key
      body['account_id'] = @account_id
      options.merge!({ body: body })
      self.class.send(__method__, path, options)
    end

    def get(path, options)
      query = {}
      query['api_key'] = @api_key
      query['account_id'] = @account_id
      options.merge!({ query: query})
      self.class.send(__method__, path, options)
    end

    def endpoint(name, method, path='/', options={}, &block)
      Query.instance_eval do 
        define_method(name) do |account_id=nil|
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
    end

    def entry(description='',duration='',contact_id='',task_ids='')
      # setting headers causes a 500 internal server error
      # headers = { 'Accept': 'application/json', 'Content-Type': 'multipart/form-data; boundary=---011000010111000001101001' }
      headers = {}
      body = {}
      body['api_key'] = API_KEY
      body['entry[description]'] = description
      body['entry[duration]'] = duration
      body['entry[contact_id]'] = contact_id
      body['entry[task_ids]'] = task_ids
      self.class.post('/entries.json', body: body, headers: headers )
    end

  end
end
