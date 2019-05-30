require "spec_helper"

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
    
    let(:info) {subject.info}
    
    it 'returns info about the underlying token' do
      expect(info).to be_a Hash
      expect(info).to include("scan_credits", "usage_limits")
    end
  end

  describe '#host' do
    let(:ip) { "8.8.8.8" }

    def check
      if Async::Task.current?
        resp = subject.host(ip).wait
      else
        resp = subject.host(ip)
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
        resp = subject.host_count(query).wait
      else
        resp = subject.host_count(query)
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
        resp = subject.host_search(query).wait
      else
        resp = subject.host_search(query)
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
        resp = subject.host_search_tokens(query).wait
      else
        resp = subject.host_search_tokens(query)
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
        resp = subject.ports.wait
      else
        resp = subject.ports
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
        resp = subject.protocols.wait
      else
        resp = subject.protocols
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
        resp = subject.profile.wait
      else
        resp = subject.profile
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
        resp = subject.community_queries.wait
      else
        resp = subject.community_queries
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
        resp = subject.search_for_community_query(query).wait
      else
        resp = subject.search_for_community_query(query)
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
        resp = subject.resolve(hostname).wait
      else
        resp = subject.resolve(hostname)
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
        resp = subject.reverse_lookup(ip).wait
      else
        resp = subject.reverse_lookup(ip)
      end
      expect(resp).to be_a(Hash)
      expect(resp[ip]).to be_a(Array)
      expect(resp[ip].first).to eq('google-public-dns-a.google.com')
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
        resp = subject.http_headers.wait
      else
        resp = subject.http_headers
      end
      expect(resp).to be_a(Hash)
      # TODO figure out why there are two content length headers?
      expect(resp['Content_Length']).to be_a(String)
      expect(resp['Content_Length']).to eq('0')
      expect(resp['Content-Length']).to be_a(String)
      expect(resp['Content-Length']).to eq('0')
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
        resp = subject.my_ip.wait
      else
        resp = subject.my_ip
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
        resp = subject.honeypot_score(ip).wait
      else
        resp = subject.honeypot_score(ip)
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
