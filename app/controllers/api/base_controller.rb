module Api
  # this is base Controller for Api
  class BaseController < ActionController::Base
    # setup value to :null_session for Api
    protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }

    # authenticate token
    before_action :authenticate_token
    # authenticate by Devise
    before_action :authenticate_user!

    # use rescue_from
    rescue_from ActiveRecord::RecordNotFound do |error|
      if request.format.json?
        record_not_found(error)
      else
        super
      end
    end

    private
      def tags_list
        params[:tags_list].to_s.split("/")
      end

      def record_not_found(error)
        render json: {error: error.message}, status: :not_found and return
      end

    protected

      def authenticate_token
        # token sent from HTTP Headers
        valid = authenticate_or_request_with_http_token do |token, options|
          @token      = token
          @api_key    = ApiKey.find_by_apikey(token)
        end
        # do early return if :apikey not valid
        # render json: {message: I18n.t("failure.apikey.invalid")}, status: :unauthorized and return if not valid

        # render json: {message: I18n.t("failure.apikey.invalid")}, status: :unauthorized and return if @api_key.blank? or not valid

        render json: {message: I18n.t("failure.apikey.expired")}, 
          status: :unprocessable_entity and return if @api_key.is_expired? if @api_key
        # make sign_in
        sign_in @api_key.user, store: false if @api_key
      end

      def render_error error
        render json: error, status: error.status
      end

      # overried authenticate_or_request_with_http_token method
      # to make it response as json when request using Api
      # def authenticate_or_request_with_http_token(realm = "Application")
      #   self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
      #   if env["REQUEST_PATH"] =~ /^\/api/
      #     self.__send__ :render, :json => {error: "HTTP Token: Access denied.\n"}.to_json, :status => :unauthorized
      #   else
      #     self.__send__ :render, :text => "HTTP Token: Access denied.\n", :status => :unauthorized and return
      #   end
      # end

  end # BaseController
end # Api
