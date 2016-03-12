require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  # since we don't testing token anymore and this test was passed in sessions controller rspec
  # we just always return this true. This is inside ControllerMacros
  authenticate_token_always_true

  login_user
  # make sure jbuilder is rendered to get json result
  render_views

  describe "GET #index" do
    before(:each) do
      get :index, {format: :json}
    end

    it "create instance @users" do
      expect(assigns(:users)).not_to be_nil
    end

    it "return 200 response" do
      expect(response).to be_success
    end

    it "get valid json" do
      res = jresponse
      expect(res.keys).to contain_exactly("users","total")
    end
  end

  describe "GET #show" do
    context "when record found" do
      before(:each) do
        # assign instance @api_key, because it didn't exists since we bypass authenticate_token
        controller.instance_variable_set(:@api_key, subject.current_user.api_key)
        get :show, {format: :json}
      end

      it "will create instance @user" do
        expect(assigns(:user)).not_to be_nil
      end

      it "return 200 response" do
        expect(response).to be_success
      end

      it "get valid json" do
        res = jresponse
        expect(res.keys).to contain_exactly("user", "api_key", "user_found")
      end

    end

    context "when record not found" do
      it "should not create instance @user" do
        # make user sign_out first
        sign_out subject.current_user
        get :show, {format: :json}
        expect(assigns(:user)).to be_nil
      end

      it "return 401 response if api_key not exists in exchange record not found" do
        sign_out subject.current_user
        get :show, {format: :json}
        expect(response.code.to_i).to eq(401)
      end
    end
  end

  describe "PATCH #change_password" do
    let(:valid_attr) {{password_confirmation: "11223344", password: "11223344", current_password: "11223344"}}
    let(:invalid_attr) {{password_confirmation: "11223344", password: "1231211223344", current_password: "1231211223344"}}

    context "when params valid" do
      before(:each) do
        patch :change_password, {user: valid_attr, format: :json}
      end

      it "will update password" do
        expect(assigns(:user)).not_to be_nil
      end

      it "return 200 response" do
        expect(response).to be_success
      end

      it "get valid json" do
        res = jresponse
        expect(res.keys).to contain_exactly("api_key", "user")
      end
    end

    context "when params invalid" do
      before(:each) do
        patch :change_password, {user: invalid_attr, format: :json}
      end

      it "will fails update password and get 422 response" do
        expect(response.code.to_i).to eq(422)
      end
    end
  end
end
