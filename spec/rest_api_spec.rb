# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Shodanz::API::REST do
  before do
    # try to avoid rate limit
    sleep 1
  end

  describe '#info' do
    include_context Async::RSpec::Reactor

    after do
      subject.close
    end

    let(:info) { subject.info }

    it 'returns info about the underlying token' do
      expect(info).to be_a Hash
      expect(info).to include('scan_credits', 'usage_limits')
    end
  end

  describe '#host' do
    include_context Async::RSpec::Reactor

    after do
      subject.close
    end

    let(:resp) { subject.host('8.8.8.8') }

    it 'returns all services that have been found on the given host IP' do
      expect(resp).to be_a(Hash)
    end
  end

  describe '#host_count' do
    include_context Async::RSpec::Reactor

    after do
      subject.close
    end

    let(:resp) { subject.host_count('apache') }

    it 'returns the total number of results that matches a given query' do
      expect(resp).to be_a(Hash)
    end
  end

  describe '#host_search' do
    include_context Async::RSpec::Reactor

    after do
      subject.close
    end

    let(:resp) { subject.host_search('apache') }

    it 'returns the total number of results that matches a given query' do
      expect(resp).to be_a(Hash)
    end
  end

  describe '#host_search_tokens' do
    include_context Async::RSpec::Reactor

    after do
      subject.close
    end

    let(:query) { 'apache' }

    let(:resp) { subject.host_search_tokens(query) }

    it 'returns a parsed version of the query' do
      expect(resp).to be_a(Hash)
      expect(resp['attributes']).to be_a(Hash)
      expect(resp['errors']).to be_a(Array)
      expect(resp['filters']).to be_a(Array)
      expect(resp['string']).to be_a(String)
      expect(resp['string']).to eq(query)
    end
  end

  describe '#ports' do
    include_context Async::RSpec::Reactor

    after do
      subject.close
    end

    let(:resp) { subject.ports }

    it 'returns a list of port numbers that the crawlers are looking for' do
      expect(resp).to be_a(Array)
    end
  end

  describe '#protocols' do
    include_context Async::RSpec::Reactor

    after do
      subject.close
    end

    let(:resp) { subject.protocols }

    it 'returns all protocols that can be used when performing on-demand scans' do
      expect(resp).to be_a(Hash)
    end
  end

  describe '#profile' do
    include_context Async::RSpec::Reactor

    after do
      subject.close
    end

    let(:resp) { subject.profile }

    it 'returns information about the shodan account' do
      expect(resp).to be_a(Hash)
      expect(resp['member']).to be(true).or be(false)
      expect(resp['credits']).to be_a(Integer)
      expect(resp['created']).to be_a(String)
      expect(resp.key?('display_name')).to be(true)
    end
  end

  describe '#community_queries' do
    include_context Async::RSpec::Reactor

    after do
      subject.close
    end

    let(:resp) { subject.community_queries }

    it 'obtains a list of search queries that users have saved' do
      expect(resp).to be_a(Hash)
      expect(resp['total']).to be_a(Integer)
      expect(resp['matches']).to be_a(Array)

      example_match = resp['matches'].first

      expect(example_match['votes']).to be_a(Integer)
      expect(example_match['description']).to be_a(String)
      expect(example_match['tags']).to be_a(Array)
      expect(example_match['timestamp']).to be_a(String)
      expect(example_match['title']).to be_a(String)
      expect(example_match['query']).to be_a(String)
    end
  end

  describe '#search_for_community_query' do
    include_context Async::RSpec::Reactor

    after do
      subject.close
    end

    let(:resp) { subject.search_for_community_query('apache') }

    it 'search the directory of search queries that users have saved' do
      expect(resp).to be_a(Hash)
      expect(resp['total']).to be_a(Integer)
      expect(resp['matches']).to be_a(Array)

      example_match = resp['matches'].first

      expect(example_match['votes']).to be_a(Integer)
      expect(example_match['description']).to be_a(String)
      expect(example_match['tags']).to be_a(Array)
      expect(example_match['timestamp']).to be_a(String)
      expect(example_match['title']).to be_a(String)
      expect(example_match['query']).to be_a(String)
    end
  end

  describe '#resolve' do
    include_context Async::RSpec::Reactor

    after do
      subject.close
    end

    let(:resp) { subject.resolve('google.com') }

    it 'resolves domains to ip addresses' do
      expect(resp).to be_a(Hash)
    end
  end

  describe '#reverse_lookup' do
    include_context Async::RSpec::Reactor

    after do
      subject.close
    end

    let(:ip) { '8.8.8.8' }

    let(:resp) { subject.reverse_lookup(ip) }

    it 'resolves ip addresses to domains' do
      expect(resp).to be_a(Hash)
      expect(resp[ip]).to be_a(Array)
      expect(resp[ip].first).to eq('google-public-dns-a.google.com')
    end
  end

  describe '#http_headers' do
    include_context Async::RSpec::Reactor

    after do
      subject.close
    end

    let(:resp) { subject.http_headers }

    it 'shows the HTTP headers that your client sends when connecting to a webserver' do
      expect(resp).to be_a(Hash)
      # TODO: figure out why there are two content length headers?
      expect(resp['Content_Length']).to be_a(String)
      expect(resp['Content_Length']).to eq('0')
      expect(resp['Content-Length']).to be_a(String)
      expect(resp['Content-Length']).to eq('0')
      # TODO: maybe specify a content-type?
      expect(resp['Content-Type']).to be_a(String)
      expect(resp['Content-Type']).to eq('')
      expect(resp['Host']).to be_a(String)
      expect(resp['Host']).to eq('api.shodan.io')
    end
  end

  describe '#my_ip' do
    include_context Async::RSpec::Reactor

    after do
      subject.close
    end

    let(:resp) { subject.my_ip }

    it 'shows the current IP address as seen from the internet' do
      expect(resp).to be_a(String)
    end
  end

  describe '#honeypot_score' do
    include_context Async::RSpec::Reactor

    after do
      subject.close
    end

    let(:resp) { subject.honeypot_score('8.8.8.8') }

    it 'returns the calculated likelihood a given IP is a honeypot' do
      expect(resp).to be_a(Float)
      expect(resp).to eq(0.0)
    end
  end
end
