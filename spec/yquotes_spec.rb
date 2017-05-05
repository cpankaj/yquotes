require "spec_helper"

RSpec.describe YQuotes do
  it "has a version number" do
    expect(YQuotes::VERSION).not_to be nil
  end

  it "has valid parameters" do
    expect(YQuotes::Yahoo.build_params('indigo.ns')).to eq('s=indigo.ns&g=d')
    expect(YQuotes::Yahoo.build_params('indigo.ns', '2017-01-01', '2017-03-31')).to eq('s=indigo.ns&a=0&b=1&c=2017&d=2&e=31&f=2017&g=d')
  end
end
