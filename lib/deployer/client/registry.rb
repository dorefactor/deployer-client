require 'httparty'

module Deployer
  module Client
    class Registry
      include HTTParty
      base_uri 'https://somehosts'

      def initialize()
        @auth = { 
          username: 'u', 
          password: 'p' 
        }
      end
    
      def ping
        perform_get_request('/v2/')
      end

      def _catalog_v2(limit = "?n=200")
        perform_get_request("/v2/_catalog#{limit}")
      end

      def tags(image)
        perform_get_request("/v2/#{image}/tags/list")
      end

      private

      def perform_get_request(path)
        stripe_error do
          response = self.class.get(path, @auth)
          handle_response(response)
        end
      end

      def handle_response(result)
        json_parse_body = JSON.parse(result.body)

        case(result.message)
        when 'OK'
          return Model::Base.create_success(json_parse_body)
        when 'Unauthorized'
          return Model::Base.create_error('UNAUTHORIZED, bad credentials')
        end
      end

      def stripe_error
        yield
      rescue SocketError => e
        Model::Base.create_error(e.to_s)
      rescue Exception => e
        Model::Base.create_error(e.to_s)
      end

    end
  end
end