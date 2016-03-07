module Api
  module V1
    # inherit from Api::BaseController
    class SessionsController < Api::BaseController
      # skip authentication when sign_in process
      skip_before_filter :authenticate_user!, only: :create

      # POST /api/v1/users/sign_in 
      def create
        user = User.find_by_email(params[:email])

        if user && user.valid_password?(params[:password])
          sign_in(user, store: false)
          # create api_key
          user.create_apikey
          @api_key = user.api_key

        else
          render json: {message: I18n.t("devise.failure.not_found_in_database", authentication_keys: "email"), status: 401}
        end
      end

      # DELETE /api/v1/users/sign_out
      def destroy
        
      end

    end # SessionsController
  end # V1
end # end Api

