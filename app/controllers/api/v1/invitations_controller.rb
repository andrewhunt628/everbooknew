module Api
  module V1
    # class InvitationsController < Devise::InvitationsController
    class InvitationsController < Api::BaseController
      # POST /api/v1/users/invitation
      def create
        render json: {message: I18n.t("failure.invite.email_missing")}, 
          status: :unprocessable_entity and return if params[:email].blank?
        # invite email
        ::User.invite!({email: params[:email]}, current_user)
      end

    end # InvitationsController
  end # V1
end # Api
