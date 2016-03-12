class UsersController < ApplicationController
  before_action :set_user

  def show
  end

  def form_change_password
  end

  def change_password
    if @user.update_with_password(user_params)
      # to bypass validation
      sign_in @user, bypass: true
      redirect_to root_url
    else
      render :form_change_password
    end
  end

  private 
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation, :current_password)
    end
end
