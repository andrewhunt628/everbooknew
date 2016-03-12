module Api
  module V1
    # inherit from Api::BaseController
    class SessionsController < Api::BaseController
      # skip authentication when sign_in process
      skip_before_action :authenticate_token, only: :create
      skip_before_action :authenticate_user!, only: :create

      # POST /api/v1/users/sign_in 
      def create
        user = ::User.find_by_email(params[:email])

        if user && user.valid_password?(params[:password])
          # make user sign in
          sign_in(user, store: false)
          # create api_key
          user.create_apikey
          @api_key = user.api_key

        else
          render json: {message: I18n.t("devise.failure.not_found_in_database", authentication_keys: "email")}, status: :unauthorized
        end
      end

      # DELETE /api/v1/users/sign_out
      def destroy
        @user     = @api_key.user
        # do early return if user not found with current :apikey
        render json: {message: I18n.t("failure.user.not_found")}, status: :unprocessable_entity and return if @user.blank?
        # make user sign out
        sign_out @user
        # destroy token, make sure it's not re-used
        @api_key.destroy
      end

    end # SessionsController
  end # V1
end # end Api

