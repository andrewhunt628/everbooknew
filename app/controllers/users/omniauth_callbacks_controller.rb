class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def self.provides_callback_for(provider)
    class_eval <<-RUBY

      def #{provider}
        @user = User.find_for_oauth(env["omniauth.auth"], current_user)
        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    RUBY
  end

  # https://graph.facebook.com/me?fields=email&access_token=CAAX0jh39x60BADIy5ZAUwHc7azx3iIDRc8D4Vw0Op2WMoVDuM7EfG5uPyRJVWHbV6T4EZBHMvEMBdA7ZAE0BmvJCEXlj1ZAutPF9KpKoReSi6iQHnvxsUs9ZC0QaCbHKDow2mzBbSJz3ZBxNtEtHs7rymSQjtzyzNvWmobNza7epMlXm1UC09sARtcKGXohIIZD
  # temporary comment
  # def google_oauth2
  #   # You need to implement the method below in your model (e.g. app/models/user.rb)
  #   @user = User.from_omniauth(request.env["omniauth.auth"])
    
  #   if @user.persisted?
  #     flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
  #     sign_in_and_redirect @user, :event => :authentication
  #   else
  #     session["devise.google_data"] = request.env["omniauth.auth"]
  #     redirect_to new_user_registration_url
  #   end
  # end

  [:facebook, :google_oauth2].each do |provider|
    provides_callback_for(provider)
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_signup_path(resource)
    end
  end

  def failure
    redirect_to root_path
  end
end
