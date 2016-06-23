require 'spec_helper'

describe Fourth::Query do
  it 'defines a status method' do
    query = Fourth::Query.new
    expect(query.status).not_to be nil
  end
end
