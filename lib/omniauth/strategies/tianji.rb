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

      uid { raw_info['uid'] }

      info do
        {
          "uid" => raw_info["uid"], 
          "gender"=> (raw_info['gender'] == '0' ? 'Male' : 'Female'), 
          "image"=>raw_info['logo50'],
          'name' => raw_info['name'],
          'urls' => {
            'Kaixin' => "http://www.kaixin001.com/"
          }
        }
      end

      def raw_info
        @raw_info ||= MultiJson.decode(access_token.get("http://api.tianji.com/me.json?access_token=#{@access_token.token}").body)
        puts @raw_info.inspect
        @raw_info
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end
    end
  end
end