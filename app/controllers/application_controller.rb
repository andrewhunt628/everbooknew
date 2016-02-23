class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :authenticate_user!
  helper_method :tags_list

  private
    def tags_list
      params[:tags_list].to_s.split("/")
    end

end
