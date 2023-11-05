require "spec_helper"

RSpec.describe Shodanz::API::Streaming do
  include_context Async::RSpec::Reactor

  before do
    @client = Shodanz.api.streaming.new
  end

  before(:each) do
    # try to avoid rate limit
    sleep 1
  end

  describe '#banners' do
    it "should stream any banner data Shodan collects" do
      reactor.async do
        @client.banners(limit: 1) do |banner|
          expect(banner).to be_a(Hash)
        end
      end
    end
  end
end
