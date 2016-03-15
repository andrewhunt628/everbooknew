module Api
  module V1
    module User
      class OauthVerificationsController < Api::BaseController
        skip_before_action :authenticate_token, only: :verify_google_token
        skip_before_action :authenticate_user!, only: :verify_google_token

        def verify_google_token
          # here is example response when request authorization via google oauth.
          # you need to send this token="ya29.ogIikL6fqBJYMhUwhOLTwFIccrrOkOxXj6H2krTrRcDJP5P3hDAfkW_QSW1cMqOxsg"

          # or for more clear format https://github.com/zquestz/omniauth-google-oauth2#auth-hash

          #<OmniAuth::AuthHash credentials=#<OmniAuth::AuthHash expires=true expires_at=1457714407 refresh_token="1/kVM1eaToWPFTouaJy4NwbxTKNAOpyToV1n51tDqmodIMEudVrK5jSpoR30zcRFq6" token="ya29.ogIikL6fqBJYMhUwhOLTwFIccrrOkOxXj6H2krTrRcDJP5P3hDAfkW_QSW1cMqOxsg"> extra=#<OmniAuth::AuthHash id_info=#<OmniAuth::AuthHash at_hash="VMe4a--nqQZWgkGHzBRGyg" aud="112315637553-lutnuf4cdublss4kr6hnctnvlbrdhsa9.apps.googleusercontent.com" azp="112315637553-lutnuf4cdublss4kr6hnctnvlbrdhsa9.apps.googleusercontent.com" email="opan.neutron@gmail.com" email_verified=true exp=1457714407 iat=1457710807 iss="accounts.google.com" sub="116602758080555792557"> id_token="eyJhbGciOiJSUzI1NiIsImtpZCI6IjgxYzA1NGM3YTY1YzA0NmQ1MWI3Mjc3N2JkYTk1YzdjYjFjMmU4ZWIifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiYXRfaGFzaCI6IlZNZTRhLS1ucVFaV2drR0h6QlJHeWciLCJhdWQiOiIxMTIzMTU2Mzc1NTMtbHV0bnVmNGNkdWJsc3M0a3I2aG5jdG52bGJyZGhzYTkuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTY2MDI3NTgwODA1NTU3OTI1NTciLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXpwIjoiMTEyMzE1NjM3NTUzLWx1dG51ZjRjZHVibHNzNGtyNmhuY3RudmxicmRoc2E5LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiZW1haWwiOiJvcGFuLm5ldXRyb25AZ21haWwuY29tIiwiaWF0IjoxNDU3NzEwODA3LCJleHAiOjE0NTc3MTQ0MDd9.hNA_vIK-tMq9Y9UVmAf3akKSWHTFXboTbHTWVvP16-j4ZEGOEHvn0mpTvryKHgU5d7CaPAYVgYkKVA0TSmrHTXz5WSKPBJj92vApmHLRyPcqPuA_41VJ-JcYypJVFLWIPBLYNhb0MaP60NlPfAvUNm-jr8_6dqTksJdga-SgGyr_5gizjBCXgJuya5oeIdeex3t9om6KWT1_Z-lsAI1zfniQz4y9-gG9HS1ruSDGl21P3qEz6RTOB-FtioU7g09zJfTnkElD8REK32TSDJLO3gt2pSkSS6kMryCRyFIawJ9OBoKoLD1FD9tsvOaQcbV1DF0hsw55mpYTONlCtagIkw" raw_info=#<OmniAuth::AuthHash email="opan.neutron@gmail.com" email_verified="true" family_name="Mustopah" gender="male" given_name="Opan" kind="plus#personOpenIdConnect" locale="in" name="Opan Mustopah" picture="https://lh5.googleusercontent.com/-M07x0Zu1j8w/AAAAAAAAAAI/AAAAAAAACaY/wj09dv4faUg/photo.jpg?sz=50" profile="https://plus.google.com/116602758080555792557" sub="116602758080555792557">> info=#<OmniAuth::AuthHash::InfoHash email="opan.neutron@gmail.com" first_name="Opan" image="https://lh5.googleusercontent.com/-M07x0Zu1j8w/AAAAAAAAAAI/AAAAAAAACaY/wj09dv4faUg/photo.jpg" last_name="Mustopah" name="Opan Mustopah" urls=#<OmniAuth::AuthHash Google="https://plus.google.com/116602758080555792557">> provider="google_oauth2" uid="116602758080555792557">
          
          # the scenario is, mobile device will call google oauth,
          # when valid, get "access token" response from that request
          # and then send them here. One this controller is called, 
          # it will call onether google API to get "user info" using "access token".
          # if response OK, then query to table User, do validation (or create if doesn't exists)
          # and than return the api_key.
          # and don't forget to send "provider" and "uid" too if you want to record them

          # article references: http://blog.jachobsen.com/2013/08/10/google-oauth2-in-android-with-rails-backend/#oauth-part

          token     = params[:token]
          uid       = params[:uid]
          provider  = params[:provider]
          # do early return if params token missing
          render json: {message: I18n.t("failure.oauth.token_missing")}, status: :forbidden and return unless token

          response = HTTParty.get("https://www.googleapis.com/oauth2/v2/userinfo",
            headers: {"Access_token" => token, "Authorization" => "OAuth #{token}"})

          if response.code.eql? 200
            data = JSON.parse(response.body)
            @user = ::User.find_for_verify_google_token(data.symbolize_keys, uid, provider)

            render json: {message: I18n.t("devise.failure.not_found_in_database", authentication_keys: "email")}, 
              status: :unprocessable_entity if not @user.persisted?
            sign_in @user, store: false
          else
            render json: response, status: response.code.to_i and return
          end
        end

      end # OauthVerificationsController
    end # User
  end # V1
end # Api
