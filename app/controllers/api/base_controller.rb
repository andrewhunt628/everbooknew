module Api
  # this is base Controller for Api
  class BaseController < ActionController::Base
    # setup value to :null_session for Api
    protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }
    
    # authenticate by Devise
    before_filter :authenticate_user!
    # authenticate token
    before_filter :authenticate_token

    protected

      def authenticate_token
        
      end

  end # BaseController
end # Api
