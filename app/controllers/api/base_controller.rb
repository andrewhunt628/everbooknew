module Api
  # this is base Controller for Api
  class BaseController < ActionController::Base
    # setup value to :null_session for Api
    protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }
    
    # authenticate token
    before_action :authenticate_token
    # authenticate by Devise
    before_action :authenticate_user!

    private
      def tags_list
        params[:tags_list].to_s.split("/")
      end

    protected

      def authenticate_token
        # token sent from HTTP Headers
        valid = authenticate_or_request_with_http_token do |token, options|
          @api_key   = ApiKey.find_by_apikey(token)
        end
        # do early return if :apikey not valid
        render json: {message: I18n.t("failure.apikey.invalid")}, status: :unauthorized and return if not valid
        render json: {message: I18n.t("failure.apikey.invalid")}, status: :unauthorized and return if @api_key.blank?
        # do early return if :apikey already expired 
        render json: {message: I18n.t("failure.apikey.expired")}, status: :unprocessable_entity and return if @api_key.is_expired?
        # make sign_in
        sign_in @api_key.user, store: false
      end

  end # BaseController
end # Api
