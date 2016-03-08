module Api
  module V1
    # inherit from Devise passwords controller
    class PasswordsController < Devise::PasswordsController
      # setup value to :null_session for Api
      protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }

      # POST /api/v1/users/password
      def create
        self.resource = resource_class.send_reset_password_instructions(resource_params)
        yield resource if block_given?
        render json: {message: resource.errors.full_messages}, 
          status: :unauthorized and return if not successfully_sent?(resource)
      end

      # PUT /api/v1/users/password
      def update
        # must sent reset_password_token
        self.resource = resource_class.reset_password_by_token(resource_params)
        yield resource if block_given?

        if resource.errors.empty?
          resource.unlock_access! if unlockable?(resource)

          if Devise.sign_in_after_reset_password
            flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
            if resource.active_for_authentication?
              @message    = I18n.t("devise.passwords.updated")
            else
              @message    = I18n.t("devise.passwords.updated_not_active")
            end
            # set_flash_message!(:notice, flash_message)
            sign_in(resource, store: false)
          else
            @message      = I18n.t("devise.passwords.updated_not_active")
          end

          render json: {message: flash_message}, status: :unauthorized
        else
          set_minimum_password_length
          render json: {message: resource.errors.full_messages}, 
            status: :unprocessable_entity and return
        end
      end

    end # PasswordsController
  end # V1
end # Api
