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

  def finish_signup
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)

        # if module Devise :confirmable not included, then add this conditions
        @user.skip_reconfirmation! if @user.respond_to?(:skip_reconfirmation)

        sign_in(@user, :bypass => true)
        redirect_to @user, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private 
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation, :current_password, :email)
    end
end
