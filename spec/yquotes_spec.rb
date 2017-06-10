require 'spec_helper'

RSpec.describe YQuotes do
  before do
    @client = YQuotes::Client.new
  end

  it 'should have a version' do
    expect(YQuotes::VERSION).not_to be nil
  end

  it 'should be able to fetch dataframe' do
    options = { s: '2017-01-01', e: '2017-01-31', p: 'd' }
    expect(@client.get_quote('indigo.ns', options).class).to eq(Daru::DataFrame)
    expect(@client.get_quote('vguard.ns', options).class).to eq(Daru::DataFrame)
  end

  it 'should return a valid dataframe' do
    options = { s: '2012-01-01', e: '2017-01-31', p: 'w' }
    df = @client.get_quote('aapl', options)
    expect(df.vectors.size).to eq(7)
    expect(df[:open].class).to eq(Daru::Vector)
    expect(df[:close].class).to eq(Daru::Vector)
    expect(df[:high].class).to eq(Daru::Vector)
    expect(df[:low].class).to eq(Daru::Vector)
    expect(df[:volume].class).to eq(Daru::Vector)
    expect(df[:adj_close].class).to eq(Daru::Vector)
  end

  it 'should not check strict volume' do
    options = { s: '2017-01-01', e: '2017-01-31', p: 'd' }
    client = YQuotes::Client.new(false)
    df = client.get_quote('FFFHX', options)
    expect(df.class).to eq(Daru::DataFrame)
  end

end
