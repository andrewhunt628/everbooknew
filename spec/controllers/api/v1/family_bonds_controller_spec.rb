require 'rails_helper'

RSpec.describe Api::V1::FamilyBondsController, type: :controller do
  # since we don't testing token anymore and this test was passed in sessions controller rspec
  # we just always return this true. This is inside ControllerMacros
  authenticate_token_always_true

  login_user
  
  render_views
  
  let(:user)          { FactoryGirl.create(:user) }
  let(:family_member) { FactoryGirl.create(:user) }
  
  let(:valid_session) {{}}
  let(:invalid_attributes) {{family_member_two_id: nil}}
  let(:valid_attributes) do
    {
      family_member_two_id: family_member.id
    }
  end

  describe "POST #create" do
    context "when params valid" do
      before(:each) do
        post :create, {family_bond: valid_attributes, format: :json}
      end

      it "will create family_bond" do
        expect(assigns(:family_bond).id).not_to be_nil
      end

      it "return 200 response" do
        expect(response).to be_success
      end

      it "get valid json" do
        res = jresponse
        expect(res.keys).to contain_exactly("user", "api_key", "message", "family_bond")
      end
    end

    context "when params invalid" do
      before(:each) do
        post :create, {family_bond: invalid_attributes, format: :json}
      end

      it "will fails create family_bond" do
        expect(assigns(:family_bond).id).to be_nil
      end

      it "return 422 response" do
        expect(response.code.to_i).to eq(422)
      end
    end
  end

  describe "GET #index" do
    before(:each) do
      get :index, {format: :json}
    end

    it "will create instance @family_bonds" do
      expect(assigns(:family_bonds)).not_to be_nil
    end

    it "return 200 response" do
      expect(response).to be_success
    end
  end

  describe "DELETE #destroy" do
    context "when family_bond found" do
      before(:each) do
        @family_bond = FamilyBond.create(valid_attributes.merge(family_member_one_id: subject.current_user.id))
      end

      it "will destroy family_bond" do
        expect {
          delete :destroy, {id: @family_bond.id, format: :json}
        }.to change(FamilyBond, :count).by(-1)
      end

      it "return 200 response" do
        delete :destroy, {id: @family_bond.id, format: :json}
        expect(response).to be_success
      end
    end

    context "when family_bond not found" do
      it "will get response 404 " do
        delete :destroy, {id: 1, format: :json}
        expect(response.code.to_i).to eq(404)
        # expect {
        #   delete :destroy, {id: 1, format: :json}
        # }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
