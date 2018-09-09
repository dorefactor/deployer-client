require 'spec_helper'

describe Deployer::Client::Registry do 
  let (:client_registry) { Deployer::Client::Registry.new  }
  let (:net_http_ok) do 
    Net::HTTPOK.new('1.1', 200, 'OK')
  end
  let(:good_response_v2_catalog) do
    <<-JSON
      { 
        "repositories": ["demo1", "demo2"] 
      }
    JSON
  end
  let(:good_response_tag) do
    <<-JSON
    {
      "name" : "demo1",
      "tags" : ["1.1"]
    }
    JSON
  end
  let(:response_unathorized) do
    <<-JSON
    {
      "errors":[
        {
          "code": "UNAUTHORIZED",
          "message": "authentication required",
          "detail": null
        }
      ]
    }
    JSON
  end

  context 'happy path' do
    it 'ping' do
      allow(net_http_ok).to receive(:body).and_return("{}")
      allow(Deployer::Client::Registry).to \
        receive(:get).and_return(net_http_ok)

      ping_result = client_registry.ping
      expect(ping_result.success?).to be_eql(true)
      expect(ping_result.out).to be_instance_of(Hash)
    end

    it '_catalog_v2' do
      allow(net_http_ok).to receive(:body).and_return(good_response_v2_catalog)
      allow(Deployer::Client::Registry).to receive(:get).and_return(net_http_ok)

      catalog_v2_result = client_registry._catalog_v2
      expect(catalog_v2_result.success?).to be_eql(true)
      expect(catalog_v2_result.out).to be_instance_of(Hash)
      expect(catalog_v2_result.out.key?('repositories')).to be_eql(true)
      expect(catalog_v2_result.out['repositories']).to be_instance_of(Array)
    end

    it 'tags' do
      allow(net_http_ok).to receive(:body).and_return(good_response_tag)
      allow(Deployer::Client::Registry).to receive(:get).and_return(net_http_ok)

      tags_result = client_registry.tags('demo1')
      expect(tags_result.success?).to be_eql(true)
      expect(tags_result.out).to be_instance_of(Hash)
    end
  end
  
  context 'errors' do
    it 'Socket error' do
      socket_error = SocketError.new('wasn\'t unable to connect')
      allow(Deployer::Client::Registry).to receive(:get).and_raise(socket_error)
      ping_result = client_registry.ping

      expect(ping_result.success?).not_to eql(true)
      expect(ping_result.out).to eql(:empty)
    end

    it 'Unathorized' do
      net_un_authorized = Net::HTTPUnauthorized.new('1.1', 401, 'Unauthorized')
      
      allow(net_un_authorized).to \
        receive(:body).and_return(response_unathorized)
      allow(Deployer::Client::Registry).to \
        receive(:get).and_return(net_un_authorized)
      ping_result = client_registry.ping

      expect(ping_result.success?).not_to eql(true)
      expect(ping_result.err).to eql('UNAUTHORIZED, bad credentials')
    end
  end
end