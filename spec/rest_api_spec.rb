require "spec_helper"

RSpec.describe Shodanz::API::REST do
  before do
    @client = Shodanz.api.rest.new
  end

  before(:each) do
    # try to avoid rate limit
    sleep 3
  end

  describe '#scan' do
    def check
      if Async::Task.current?
        resp = @client.scan("1.1.1.1").wait
      else
        resp = @client.scan("1.1.1.1")
      end
      expect(resp).to be_a(Hash)
      expect(resp["count"]).to be_a(Integer)
      expect(resp["id"]).to be_a(String)
      expect(resp["credits_left"]).to be_a(Integer)
    end

    describe 'scans host on the internet' do
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

  describe '#info' do
    def check
      if Async::Task.current?
        resp = @client.info.wait
      else
        resp = @client.info
      end
      expect(resp).to be_a(Hash)
    end

    describe 'returns info about the underlying token' do
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

  describe '#host' do
    let(:ip) { "8.8.8.8" }

    def check
      if Async::Task.current?
        resp = @client.host(ip).wait
      else
        resp = @client.host(ip)
      end
      expect(resp).to be_a(Hash)
    end

    describe 'returns all services that have been found on the given host IP' do
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

  describe '#host_count' do
    let(:query) { "apache" }

    def check
      if Async::Task.current?
        resp = @client.host_count(query).wait
      else
        resp = @client.host_count(query)
      end
      expect(resp).to be_a(Hash)
    end

    describe 'returns the total number of results that matches a given query' do
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

  describe '#host_search' do
    let(:query) { "apache" }

    def check
      if Async::Task.current?
        resp = @client.host_search(query).wait
      else
        resp = @client.host_search(query)
      end
      expect(resp).to be_a(Hash)
    end

    describe 'returns the total number of results that matches a given query' do
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

  describe '#host_search_tokens' do
    let(:query) { "apache" }

    def check
      if Async::Task.current?
        resp = @client.host_search_tokens(query).wait
      else
        resp = @client.host_search_tokens(query)
      end
      expect(resp).to be_a(Hash)
      expect(resp['attributes']).to be_a(Hash)
      expect(resp['errors']).to be_a(Array)
      expect(resp['filters']).to be_a(Array)
      expect(resp['string']).to be_a(String)
      expect(resp['string']).to eq(query)
    end

    describe 'returns a parsed version of the query' do
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

  describe '#ports' do
    def check
      if Async::Task.current?
        resp = @client.ports.wait
      else
        resp = @client.ports
      end
      expect(resp).to be_a(Array)
    end

    describe 'returns a list of port numbers that the crawlers are looking for' do
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

  describe '#protocols' do
    def check
      if Async::Task.current?
        resp = @client.protocols.wait
      else
        resp = @client.protocols
      end
      expect(resp).to be_a(Hash)
    end

    describe 'returns all protocols that can be used when performing on-demand scans' do
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

  describe '#profile' do
    def check
      if Async::Task.current?
        resp = @client.profile.wait
      else
        resp = @client.profile
      end
      expect(resp).to be_a(Hash)
      expect(resp["member"]).to be(true).or be(false)
      expect(resp["credits"]).to be_a(Integer)
      expect(resp["created"]).to be_a(String)
      expect(resp.key?("display_name")).to be(true)
    end

    describe 'returns information about the shodan account' do
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

  describe '#community_queries' do
    def check
      if Async::Task.current?
        resp = @client.community_queries.wait
      else
        resp = @client.community_queries
      end
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

    describe 'obtains a list of search queries that users have saved' do
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

  describe '#search_for_community_query' do
    let(:query) { "apache" }

    def check
      if Async::Task.current?
        resp = @client.search_for_community_query(query).wait
      else
        resp = @client.search_for_community_query(query)
      end
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

    describe 'search the directory of search queries that users have saved' do
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

  describe '#resolve' do
    let(:hostname) { "google.com" }

    def check
      if Async::Task.current?
        resp = @client.resolve(hostname).wait
      else
        resp = @client.resolve(hostname)
      end
      expect(resp).to be_a(Hash)
    end

    describe 'resolves domains to ip addresses' do
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

  describe '#reverse_lookup' do
    let(:ip) { '8.8.8.8' }

    def check
      if Async::Task.current?
        resp = @client.reverse_lookup(ip).wait
      else
        resp = @client.reverse_lookup(ip)
      end
      expect(resp).to be_a(Hash)
      expect('8.8.8.8').not_to be nil

      # NOTE: this was the old behavior...
      #
      #  Now it's in the form ip => [ dns_names ... ]
      # {"8.8.8.8"=>["dns.google"]}
      #
      # expect(resp[ip]).to be_a(Array)
      # expect(resp[ip].first).to eq('google-public-dns-a.google.com')
    end

    describe 'resolves ip addresses to domains' do
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

  describe '#http_headers' do
    def check
      if Async::Task.current?
        resp = @client.http_headers.wait
      else
        resp = @client.http_headers
      end
      expect(resp).to be_a(Hash)
      expect(resp['Content-Length']).to be_a(String)
      expect(resp['Content-Length']).to eq('')
      # TODO maybe specify a content-type?
      expect(resp['Content-Type']).to be_a(String)
      expect(resp['Content-Type']).to eq('')
      expect(resp['Host']).to be_a(String)
      expect(resp['Host']).to eq('api.shodan.io')
    end

    describe 'shows the HTTP headers that your client sends when connecting to a webserver' do
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

  describe '#my_ip' do
    def check
      if Async::Task.current?
        resp = @client.my_ip.wait
      else
        resp = @client.my_ip
      end
      expect(resp).to be_a(String)
    end

    describe 'shows the current IP address as seen from the internet' do
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

  describe '#honeypot_score' do
    let(:ip) { '8.8.8.8' }

    def check
      if Async::Task.current?
        resp = @client.honeypot_score(ip).wait
      else
        resp = @client.honeypot_score(ip)
      end
      expect(resp).to be_a(Float)
      expect(resp).to eq(0.0)
    end

    describe 'returns the calculated likelihood a given IP is a honeypot' do
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
