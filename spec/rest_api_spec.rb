require "spec_helper"

RSpec.describe Shodanz::API::REST do
  include_context Async::RSpec::Reactor

  before do
    @client = Shodanz.api.rest.new
  end

  before(:each) do
    # try to avoid rate limit
    sleep 3
  end

  describe '#scan' do
    it 'should be able to scan a host on the internet' do
      reactor.async do
        resp = @client.scan("1.1.1.1").wait
        expect(resp).to be_a(Hash)
        expect(resp["count"]).to be_a(Integer)
        expect(resp["id"]).to be_a(String)
        expect(resp["credits_left"]).to be_a(Integer)
      end
    end
  end

  describe '#info' do
    it 'returns info about the underlying token' do
      reactor.async do
        resp = @client.info.wait
        expect(resp).to be_a(Hash)
      end
    end
  end

  describe '#host' do
    let(:ip) { "8.8.8.8" }

    it 'returns all services that have been found on the given host IP' do
      reactor.async do
        resp = @client.host(ip).wait
        expect(resp).to be_a(Hash)
      end
    end
  end

  describe '#host_count' do
    let(:query) { "apache" }

    it 'returns the total number of results that matches a given query' do
      reactor.async do
        resp = @client.host_count(query).wait
        expect(resp).to be_a(Hash)
      end
    end
  end

  describe '#host_search' do
    let(:query) { "apache" }

    it 'returns the total number of results that matches a given query' do
      reactor.async do
        resp = @client.host_search(query).wait
        expect(resp).to be_a(Hash)
      end
    end
  end

  describe '#host_search_tokens' do
    let(:query) { "apache" }

    it 'returns a parsed version of the query' do
      reactor.async do
        resp = @client.host_search_tokens(query).wait
        expect(resp).to be_a(Hash)
        expect(resp['attributes']).to be_a(Hash)
        expect(resp['errors']).to be_a(Array)
        expect(resp['filters']).to be_a(Array)
        expect(resp['string']).to be_a(String)
        expect(resp['string']).to eq(query)
      end
    end
  end

  describe '#ports' do
    it 'returns a list of port numbers that the crawlers are looking for' do
      reactor.async do
        resp = @client.ports.wait
        expect(resp).to be_a(Array)
      end
    end
  end

  describe '#protocols' do
    it 'returns all protocols that can be used when performing on-demand scans' do
      reactor.async do
        resp = @client.protocols.wait
        expect(resp).to be_a(Hash)
      end
    end
  end

  describe '#profile' do
    it 'returns information about the shodan account' do
      reactor.async do
        resp = @client.profile.wait
        expect(resp).to be_a(Hash)
        expect(resp["member"]).to be(true).or be(false)
        expect(resp["credits"]).to be_a(Integer)
        expect(resp["created"]).to be_a(String)
        expect(resp.key?("display_name")).to be(true)
      end
    end
  end

  describe '#community_queries' do
    it 'obtains a list of search queries that users have saved' do
      reactor.async do
        resp = @client.community_queries.wait

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
  end

  describe '#search_for_community_query' do
    let(:query) { "apache" }

    it 'search the directory of search queries that users have saved' do
      reactor.async do
        resp = @client.search_for_community_query(query).wait

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
  end

  describe '#resolve' do
    let(:hostname) { "google.com" }

    it 'resolves domains to ip addresses' do
      reactor.async do
        resp = @client.resolve(hostname).wait
        expect(resp).to be_a(Hash)
      end
    end
  end

  describe '#reverse_lookup' do
    let(:ip) { '8.8.8.8' }

    it 'resolves ip addresses to domains' do
      reactor.async do
        resp = @client.reverse_lookup(ip).wait
        expect(resp).to be_a(Hash)
        expect('8.8.8.8').not_to be nil
      end
    end
  end

  describe '#http_headers' do
    it 'shows the HTTP headers that your client sends when connecting to a webserver' do
      reactor.async do
        resp = @client.http_headers.wait

        expect(resp).to be_a(Hash)
        expect(resp['Content-Length']).to be_a(String)
        expect(resp['Content-Length']).to eq('')
        # TODO maybe specify a content-type?
        expect(resp['Content-Type']).to be_a(String)
        expect(resp['Content-Type']).to eq('')
        expect(resp['Host']).to be_a(String)
        expect(resp['Host']).to eq('api.shodan.io')
      end
    end
  end

  describe '#my_ip' do
    it 'shows the current IP address as seen from the internet' do
      reactor.async do
        resp = @client.my_ip.wait
        expect(resp).to be_a(String)
      end
    end
  end
end
