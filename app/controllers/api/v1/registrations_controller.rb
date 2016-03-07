module Api
  module V1
    # inherit from Api::BaseController
    class RegistrationsController < Api::BaseController
      # skip authentication when sign_in process
      skip_before_filter :authenticate_token, only: :create
      skip_before_filter :authenticate_user!, only: :create

      def create
        
      end
    end
  end # V1
end # Api
