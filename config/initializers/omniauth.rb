require "omniauth/strategies/roblox"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :roblox,
    Rails.application.credentials.roblox[:client_id],
    Rails.application.credentials.roblox[:client_secret]
end
