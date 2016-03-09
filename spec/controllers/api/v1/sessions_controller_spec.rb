require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do

  describe "POST #create" do
    context "when email or password invalid" do
      it "should fail login" do
        user = FactoryGirl.create(:user)
        post :create, {email: user.email, password: "kjashdkjash"}, format: :json
        expect(subject.current_user).to eq(nil)
      end
    end

    context "when email and password valid" do
      it "should success login" do
        user = FactoryGirl.create(:user)
        post :create, email: user.email, password: "11223344", format: :json
        expect(subject.current_user).not_to eq(nil)
        expect(response).to render_template("api/v1/sessions/create")
      end
    end
  end
end
