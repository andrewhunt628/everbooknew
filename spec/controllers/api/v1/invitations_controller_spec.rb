require 'rails_helper'

RSpec.describe Api::V1::InvitationsController, type: :controller do
  # since we don't testing token anymore and this test was passed in sessions controller rspec
  # we just always return this true. This is inside ControllerMacros
  authenticate_token_always_true

  login_user

  render_views

  let(:user) {FactoryGirl.create(:user)}

  describe "POST #create" do
    context "when valid params" do
      before(:each) do
        post :create, {email: "super@email.com", format: :json}
      end

      it "will send email invitation to user" do
        res = jresponse
        expect(emails_test.length).to be(1)
      end

      it "return 200 response" do
        expect(response).to be_success
      end
    end
    
    context "when invalid params" do
      before(:each) do
        post :create, {email: "", format: :json}
      end

      it "will not send email invitation to user" do
        res = jresponse
        expect(emails_test.length).to be(0)
      end

      it "return 422 response" do
        expect(response.code.to_i).to eq(422)
      end
    end
  end
end
