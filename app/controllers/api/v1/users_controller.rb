module Api
  module V1
    # all Api Controller inherit from Api::BaseController
    class UsersController < Api::BaseController
      # allow random people access list of users ??
      # skip_before_action :authenticate_user!, only: :index
      # skip_before_action :authenticate_token, only: :index

      before_action :set_user, only: [:show, :change_password]

      # GET /api/v1/users
      def index 
        @users    = ::User.all
      end
      
      # GET /api/v1/users
      def show
      end

      # PATCH /api/users/security/change_password/:id
      def change_password
        render json: {message: @user.errors.full_messages}, 
          status: :unprocessable_entity and return if not @user.update_with_password(user_params)

      end

      private
        def set_user
          @user     = ::User.find(current_user.id)
        end

        def user_params
          params.require(:user).permit(:password, :password_confirmation, :current_password)
        end
    end # UsersController
  end # V1
end # Api
