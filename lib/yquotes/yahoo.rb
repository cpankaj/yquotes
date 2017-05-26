require 'open-uri'
require 'csv'
require 'date'
require 'nokogiri'

module YQuotes
  COOKIE_URL = 'https://finance.yahoo.com/quote/AAPL/history?p=AAPL'.freeze
  CRUMB_PATTERN = /\"CrumbStore\":{\"crumb\":\"(?<crumb>[^"]+)/
  QUOTE_ENDPOINT = 'https://query1.finance.yahoo.com/v7/finance/download/%{symbol}?'.freeze

  class Yahoo
    # Get cookie and crumb
    def initialize
      fetch_credentials
    end

    # fetch_csv: fetch historical quotes in csv format
    def fetch_csv(ticker, start_date = nil, end_date = nil, period = 'd')
      connection = nil

      # retry 3-times in case it sends unauthorized
      3.times do |_i|
        begin
          url = build_url(ticker, start_date, end_date, period)
          connection = open(url, 'Cookie' => @cookie)
          break
        rescue OpenURI::HTTPError => e
          fetch_credentials
        end
      end

      data = CSV.parse(connection.read, converters: :numeric)

      raise 'Yahoo.fetch_csv unable to fetch data' unless data.is_a? Array
      data
    end

    alias get_csv fetch_csv
    alias get_data fetch_csv

    private

    def fetch_credentials
      # get cookie
      page = open(COOKIE_URL)
      @cookie = page.meta['set-cookie'].split('; ', 2).first

      # get crumb
      scripts = Nokogiri::HTML(page).css('script')
      scripts.each do |s|
        next unless s.text.include? 'CrumbStore'
        pattern = s.text.match(CRUMB_PATTERN)
        @crumb = pattern['crumb']
        break
      end
    end

    # build_params: build parameters for get query
    def build_url(ticker, start_date = nil, end_date = nil, period = 'd')
      url = QUOTE_ENDPOINT
      url = format(url, symbol: URI.escape(ticker.upcase))

      params = {
        crumb: URI.escape(@crumb),
        events: 'history',
        interval: '1d'
      }

      # sanitize date
      params[:period1] = get_date(start_date).to_i unless start_date.nil?
      params[:period2] = get_date(end_date).to_i unless end_date.nil?

      params[:interval] = '1d' if period == 'd'
      params[:interval] = '1mo' if period == 'm'
      params[:interval] = '1wk' if period == 'w'

      url + params.map { |k, v| "#{k}=#{v}" }.join('&').to_s
    end

    # get_date: get date from String
    def get_date(d)
      return nil if d.nil?
      return d.to_time if d.is_a? DateTime

      if d.is_a? String

        begin
          dt = DateTime.parse(d).to_time
        rescue Exception => e
          raise "invalid param #{d} - date should be in yyyy-mm-dd format"
        end
      end
    end
  end
end
