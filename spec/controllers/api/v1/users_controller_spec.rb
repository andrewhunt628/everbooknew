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
        get :show, {id: subject.current_user.id, format: :json}
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
      before(:each) do
        get :show, {id: 1, format: :json}
      end

      it "should not create instance @user" do
        expect(assigns(:user)).to be_nil
      end

      it "return 404 response" do
        expect(response.code.to_i).to eq(404)
      end
    end
  end
end
