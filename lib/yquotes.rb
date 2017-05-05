require 'csv'
require 'daru'
require 'tmpdir'
require "yquotes/version"
require "yquotes/yahoo"

module YQuotes

	class Client

		def initialize
			@yahoo_client = Yahoo.new
		end

		# get_quote: returns Daru::DataFrame of the quote with volume and close
		def get_quote(ticker, start_date=nil, end_date=nil, period='d')
			csv = @yahoo_client.get_csv(ticker, start_date, end_date, period)
			create_from_csv(csv)
		end

		alias_method :historical_data, :get_quote
		alias_method :historical_quote, :get_quote

		private

		def create_from_csv(data)

			file_path = Dir.tmpdir() + "/#{Time.now.to_i}"

			CSV.open(file_path, 'w') do |out|
				data.each do |row|
					out << row
				end
			end

			df = nil

			df = Daru::DataFrame.from_csv(file_path, :converters => :numeric)
			File.delete(file_path) if File.exists?(file_path)

			# strip columns and create index
			df.index = Daru::Index.new(df['Date'].to_a)
			df = df['Volume', 'Adj Close']
			df.rename_vectors 'Volume' => :volume, 'Adj Close' => :close

			d = df.filter(:row) { |row| row[:volume] > 0}

			return d
		end

	end

end
