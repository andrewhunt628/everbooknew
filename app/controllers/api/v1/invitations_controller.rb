module Api
  module V1
    # class InvitationsController < Devise::InvitationsController
    class InvitationsController < Api::BaseController
      # setup value to :null_session for Api
      protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }
      
      def create
        @user     = @api_key.user

        render json: {message: I18n.t("failure.invite.email_missing")}, 
          status: :unprocessable_entity and return if params[:email].blank?
        # invite email
        User.invite!({email: params[:email]}, @user)
      end

    end # InvitationsController
  end # V1
end # Api
