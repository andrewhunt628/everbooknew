require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let(:user) {FactoryGirl.create(:user)}
  
  render_views

  describe "POST #create" do
    context "when email or password invalid" do
      it "should fail login" do
        post :create, {email: user.email, password: "kjashdkjash"}, format: :json
        expect(subject.current_user).to eq(nil)
      end
    end

    context "when email and password valid" do
      it "should success login" do
        post :create, email: user.email, password: "11223344", format: :json
        expect(subject.current_user).not_to eq(nil)
        expect(response).to render_template("api/v1/sessions/create")
      end
    end
  end

  describe "DELETE #destroy" do

    login_user

    context "when token missing or not valid" do
      it "will respond 401" do
        delete :destroy, format: :json

        expect(response.code.to_i).to eq(401)
      end
    end

    context "when token is valid" do
      it "will sign out succssfully" do
        token = subject.current_user.api_key.apikey
        @request.env["HTTP_AUTHORIZATION"] = "Token token=#{token}"
        
        delete :destroy, {format: :json}
        expect(response.code.to_i).to eq(200)
        expect(subject.current_user).to be_nil
      end
    end
  end
end
