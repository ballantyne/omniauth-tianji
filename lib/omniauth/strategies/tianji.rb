require 'omniauth-oauth2'
module OmniAuth
  module Strategies
    class Tianji < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site          => 'https://login.tianji.com/',
        :authorize_url => '/authz/oauth/authorize',
        :token_url     => '/authz/oauth/token'
      }
      def request_phase
        super
      end

      uid { raw_info['id'] }


      info do
        {
          "uid" => raw_info["id"], 
          "gender"=> raw_info['gender'],
          'contact_count' => raw_info['contact_count'],
          'location' => raw_info['location'],
          'language' => raw_info['language'],
          "image"=>raw_info['picture_large'],
          'name' => raw_info['name'],
          'title' => raw_info['headline'],
          'urls' => {
            'Tianji' => raw_info['link']
          }
        }
      end

      def raw_info
        @raw_info ||= MultiJson.decode(access_token.get("https://api.tianji.com/me?access_token=#{@access_token.token}").body)
        @raw_info
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end
    end
  end
end