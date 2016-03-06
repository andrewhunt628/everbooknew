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
          api_key = user.api_key

        else

        end
      end

      # DELETE /api/v1/users/sign_out
      def destroy
        
      end

    end # SessionsController
  end # V1
end # end Api

