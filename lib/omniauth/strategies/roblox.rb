module OmniAuth
  module Strategies
    class Roblox < OmniAuth::Strategies::OAuth2
      option :name, "roblox"

      option :client_options, {
        site: "https://apis.roblox.com",
        authorize_url: "https://apis.roblox.com/oauth/v1/authorize",
        token_url: "https://apis.roblox.com/oauth/v1/token"
      }

      option :scope, "openid profile"

      uid { raw_info["sub"] }

      info do
        {
          name: raw_info["preferred_username"],
          nickname: raw_info["preferred_username"],
          image: raw_info["picture"]
        }
      end

      def raw_info
        @raw_info ||= access_token.get("https://apis.roblox.com/oauth/v1/userinfo").parsed
      end
    end
  end
end
