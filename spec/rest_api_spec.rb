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

end
