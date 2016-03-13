class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  # before_action :ensure_signup_complete, only: [:new, :update, :destroy, :create]
  helper_method :tags_list

  def ensure_signup_complete

    return if action_name.eql? "finish_signup"

    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end

  private
    def tags_list
      params[:tags_list].to_s.split("/")
    end

end
