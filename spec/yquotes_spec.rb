require "spec_helper"

RSpec.describe YQuotes do

	before do
		options = {p: 'm', s: '2017-01-01', e: '2017-03-31'}

		@client = YQuotes::Client.new
		@df_bse = @client.get_quote('bse.ns')
		@df_indigo = @client.get_quote('indigo.ns', options)
	end

	it "should have a version" do
		expect(YQuotes::VERSION).not_to be nil
	end

	it "should be able to fetch csv" do
		expect(YQuotes::Yahoo.new.fetch_csv('indigo.ns').class).to eq(Array) 
	end

	it "should be able to fetch dataframe" do
		expect(@df_bse.class).to eq(Daru::DataFrame)
		expect(@df_bse.head(5).size).to eq(5)
	end

	it "should fetch data with start and end date" do
		expect(@df_indigo.size).to eq(3)
	end

end
