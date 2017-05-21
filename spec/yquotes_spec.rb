require "spec_helper"

RSpec.describe YQuotes do

	before do
		@client = YQuotes::Client.new
	end

	it "should have a version" do
		expect(YQuotes::VERSION).not_to be nil
	end

	it "should be able to fetch dataframe" do
		options = { s: '2017-01-01', e: '2017-01-31', p: 'd'}
		expect(@client.get_quote('indigo.ns', options).class).to eq(Daru::DataFrame)
		expect(@client.get_quote('vguard.ns', options).class).to eq(Daru::DataFrame)
	end

end
