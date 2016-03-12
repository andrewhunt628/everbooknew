require 'rails_helper'


RSpec.describe UsersController, type: :controller do

  login_user

  describe "GET #show" do
    context "when record found" do
      before(:each) do
        get :show, {id: subject.current_user.id}
      end

      it "will create instance @user" do
        expect(assigns(:user)).not_to be_nil
      end

      it "and render template show" do
        expect(response).to render_template("show")
      end
    end

    context "when record not found" do
      it "will raise ActiveRecord::RecordNotFound" do
        expect {
          get :show, {id: 1}, {}
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "GET #form_change_password" do
    before(:each) do
      get :form_change_password, {id: subject.current_user.id}
    end

    it "will create instance @user" do
      expect(assigns(:user)).not_to be_nil  
    end

    it "and render template form_change_password" do
      expect(response).to render_template("form_change_password")
    end
  end

  describe "PATCH #change_password" do
    let(:invalid_attr) {{current_password: "12312412", password: "12345678", password_confirmation: "8888"}}
    let(:valid_attr) {{current_password: "11223344", password: "12345678", password_confirmation: "12345678"}}

    context "when record found" do
      it "will create instance @user" do
        patch :change_password, {id: subject.current_user.id, user: valid_attr}
        expect(assigns(:user)).not_to be_nil
      end

      context "when params valid" do
        it "will update password" do
          patch :change_password, {id: subject.current_user.id, user: valid_attr}, {}
          expect(subject).to redirect_to(root_path)
        end
      end
      
      context "when params invalid" do
        it "will render template form_change_password" do
          patch :change_password, {user: invalid_attr, id: subject.current_user.id}, {}
          expect(response).to render_template("form_change_password")
        end
      end

    end
  end
end
