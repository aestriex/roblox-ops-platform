class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def roblox
    auth = request.env["omniauth.auth"]

    user = User.find_or_create_by!(email: "roblox_#{auth.uid}@placeholder.local") do |u|
        u.password = Devise.friendly_token[0, 20]
        u.avatar_url = auth.info.image
        u.username = auth.info.nickname
    end

    user.update!(username: auth.info.nickname, avatar_url: auth.info.image)

    sign_in_and_redirect user, event: :authentication
  end
end
