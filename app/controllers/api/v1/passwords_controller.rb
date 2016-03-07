module Api
  module V1
    class PasswordsController < ApplicationController
      # setup value to :null_session for Api
      protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }

    end # PasswordsController
  end # V1
end # Api
