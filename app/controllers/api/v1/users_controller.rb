module Api
  module V1
    # all Api Controller inherit from Api::BaseController
    class UsersController < Api::BaseController
      # setup value to :null_session for Api
      protect_from_forgery with: :null_session

    end # UsersController
  end # V1
end # Api
