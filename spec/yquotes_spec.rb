require "spec_helper"

RSpec.describe YQuotes do
	it "YQuotes vesrion check" do
		expect(YQuotes::VERSION).not_to be nil
	end

	it "YQuotes::Yahoo fetch_csv" do
		expect(YQuotes::Yahoo.new.fetch_csv('indigo.ns').class).to eq(Array) 
	end

	client = YQuotes::Client.new

	it "YQuotes::Client - get_quote" do
		expect(client.get_quote('bse.ns').class).to eq(Daru::DataFrame)
	end
end
