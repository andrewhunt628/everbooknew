module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      # setup value to :null_session for Api
      protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }

      # POST /api/v1/users/sign_up
      def create
        build_resource(sign_up_params)

        resource.save

        if resource.persisted?
          sign_up(resource_name, resource)
          @user     = current_user
          @api_key  = @user.api_key
        else
          clean_up_passwords resource

          render json: {message: resource.errors.full_messages}, status: :unauthorized and return
        end
      end

    end # RegistrationsController
  end # V1
end # Api
