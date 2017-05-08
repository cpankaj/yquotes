require "spec_helper"

RSpec.describe YQuotes do

	before do
		@client = YQuotes::Client.new
	end

	it "should have a version" do
		expect(YQuotes::VERSION).not_to be nil
	end

	it "should be able to fetch csv" do
		expect(YQuotes::Yahoo.new.fetch_csv('indigo.ns').class).to eq(Array) 
	end

	client = YQuotes::Client.new

	it "should be able to fetch dataframe" do
		expect(client.get_quote('bse.ns').class).to eq(Daru::DataFrame)
	end

	it "should fetch data with start and end date" do
		options = {period: 'm', start_date: '2017-01-01', end_date: '2017-03-31'}
		df = @client.get_quote('indigo.ns', options)
		expect(df.size).to eq(3)

		options = {p: 'm', s: '2017-01-01', e: '2017-03-31'}
		df = @client.get_quote('indigo.ns', options)

		expect(df.size).to eq(3)
	end
end
