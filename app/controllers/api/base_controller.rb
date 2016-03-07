module Api
  # this is base Controller for Api
  class BaseController < ActionController::Base
    # setup value to :null_session for Api
    protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }
    
    # authenticate token
    before_filter :authenticate_token
    # authenticate by Devise
    before_filter :authenticate_user!

    protected

      def authenticate_token
        valid = authenticate_or_request_with_http_token do |token, options|
          @api_key   = ApiKey.find_by_apikey(token)
        end

        render json: {}, status: :unauthorized and return if not valid
        # make sign_in
        sign_in @api_key.user
      end

  end # BaseController
end # Api
