module Api
  module V1
    # all Api Controller inherit from Api::BaseController
    class UsersController < Api::BaseController
      skip_before_filter :authenticate_user!, only: :index

      def index
        @users    = User.all
      end

    end # UsersController
  end # V1
end # Api
