require 'rails_helper'

RSpec.describe FamilyBondsController, type: :controller do
  let(:user)          { FactoryGirl.create(:user) }
  let(:family_member) { FactoryGirl.create(:user) }
  
  let(:valid_session) {{}}
  let(:invalid_attributes) {{family_member_two_id: nil}}
  let(:valid_attributes) do
    {
      family_member_two_id: family_member.id
    }
  end

  login_user

  describe "POST #create" do
    context "with valid params" do
      it "creates a new FamilyBond" do
        expect {
          post :create, {:family_bond => valid_attributes}, valid_session
        }.to change(FamilyBond, :count).by(1)
      end

      it "redirects to the #index page" do
        post :create, {:family_bond => valid_attributes}, valid_session
        expect(response).to redirect_to(family_bonds_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved family_bond as @family_bond" do
        post :create, {:family_bond => invalid_attributes}, valid_session
        expect(assigns(:family_bond)).to be_a_new(FamilyBond)
      end

      it "re-renders the 'new' template" do
        post :create, {:family_bond => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end
end
