require 'thor'
require 'httparty'
require 'ostruct'
require 'erb'
require 'fourth/query'

module Fourth

  class Multi < Thor
    include HTTParty

    base_uri 'https://minutedock.com/api/v1/'

    desc "entry", "make entry against multiple accounts"
    def entry()
    end

  end
end
