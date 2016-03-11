require 'rails_helper'

RSpec.describe Api::V1::AlbumsController, type: :controller do
  
  # since we don't testing token anymore and this test was passed in sessions controller rspec
  # we just always return this true. This is inside ControllerMacros
  authenticate_token_always_true

  login_user

  let(:file) { file = fixture_file_upload('/images/example1.jpg', 'image/jpeg') }

  let(:create_album) do
    Album.create! FactoryGirl.attributes_for(:album).merge(user_id: controller.current_user.id, pins_attributes: [{image: file}])
  end

  render_views

  describe "GET #index" do
    let(:req_index) {get :index, format: :json}

    it "will return 200 response" do
      req_index
      expect(response).to be_success
    end

    it "will assign @albums" do
      album = create_album
      req_index
      res = jresponse

      expect(assigns(:albums)).to eq([album])
      expect(res.keys).to contain_exactly("albums","tags","user", "api_key")
    end
  end

  describe "GET #show" do
    let(:req_show) {get :show, {id: create_album.id, format: :json}}

    it "will return 200 response" do
      req_show
      expect(response).to be_success
    end

    it "will return valid json result" do
      req_show

      res = jresponse
      expect(res.keys).to contain_exactly("album", "pins", "user", "api_key")
    end
  end
end
