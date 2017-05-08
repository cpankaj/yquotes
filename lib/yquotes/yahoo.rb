require 'open-uri'
require 'csv'
require 'date'


module YQuotes

	QUOTE_ENDPOINT="https://ichart.finance.yahoo.com/table.csv?"
	
	class Yahoo

		# fetch_csv: fetch historical quotes in csv format
		def fetch_csv(ticker, start_date=nil, end_date=nil, period='d')
			url = QUOTE_ENDPOINT + build_params(ticker, start_date, end_date, period)
			connection = open(url)
			data = CSV.parse(connection.read, :converters => :numeric)
			raise "Yahoo.fetch_csv unable to fetch data" unless data.is_a? Array
			return data
		end

		alias_method :get_csv, :fetch_csv
		alias_method :get_data, :fetch_csv

		private
		# build_params: build parameters for get query
		def build_params(ticker, start_date=nil, end_date=nil, period='d')

			params = {
				:s => URI.escape(ticker)
			}

			# sanitize date
			start_date = get_date(start_date)
			end_date = get_date(end_date)

			if start_date
				params[:a] = start_date.month - 1
				params[:b] = start_date.day
				params[:c] = start_date.year
			end

			if end_date
				params[:d] = end_date.month - 1
				params[:e] = end_date.day
				params[:f] = end_date.year
			end

			params[:g] = period if period == "d" or period == "m" or period == "y"
			
			"#{params.map  { |k,v|  "#{k}=#{v}" }.join("&")}"
		end

		# get_date: get date from String
		def get_date(d)
			return nil unless d
			return d if d.is_a? Date

			if d.is_a? String

				begin
					dt = Date.parse(d)
				rescue Exception => e
					raise "invalid param #{d} - date should be in yyyy-mm-dd format"
				end
			end
		end

	end

end