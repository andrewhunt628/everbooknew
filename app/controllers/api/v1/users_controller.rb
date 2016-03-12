module Api
  module V1
    # all Api Controller inherit from Api::BaseController
    class UsersController < Api::BaseController
      skip_before_action :authenticate_user!, only: :index

      # GET /api/v1/users
      def index 
        @users    = User.all
      end

      # GET /api/v1/users/:id
      def show
        @user     = User.find(params[:id])
      end

    end # UsersController
  end # V1
end # Api
