require "fourth/version"
require "fourth/cli"

raise 'MINUTE_DOC_API_KEY environment not set' if ENV['MINUTE_DOC_API_KEY'].empty?

module Fourth
  API_KEY = ENV['MINUTE_DOC_API_KEY']
end
