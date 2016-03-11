module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      sign_in user
    end
  end

  def authenticate_token_always_true
    before(:each) do
      allow(controller).to receive(:authenticate_token){true}
    end
  end
end
