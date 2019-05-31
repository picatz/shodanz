# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Shodanz::API::Streaming do
  before do
    @client = Shodanz.api.streaming.new
  end

  before(:each) do
    # try to avoid rate limit
    sleep 1
  end

  describe '#banners' do
    def check
      @client.banners(limit: 1) do |banner|
        expect(banner).to be_a(Hash)
      end
    end

    describe 'stream any banner data Shodan collects' do
      it 'works synchronously' do
        check
      end

      it 'works asynchronously' do
        Async do
          check
        end
      end
    end
  end
end
