require "spec_helper"

RSpec.describe Shodanz::API::REST do
  before do
    @client = Shodanz.api.rest.new
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
  
end