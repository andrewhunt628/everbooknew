require 'rails_helper'

RSpec.describe Api::V1::AlbumsController, type: :controller do
  
  # since we don't testing token anymore and this test was passed in sessions controller rspec
  # we just always return this true. This is inside ControllerMacros
  authenticate_token_always_true

  login_user

  let(:file) { file = fixture_file_upload('/images/example1.jpg', 'image/jpeg') }
  let(:valid_attributes) { FactoryGirl.attributes_for(:album) }

  let(:create_album) do
    Album.create! FactoryGirl.attributes_for(:album).merge(user_id: controller.current_user.id, pins_attributes: [{image: file}])
  end

  let(:invalid_attributes) do
    {
      title: nil,
      description: nil
    }
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

  describe "POST #create" do
    let(:req_create_invalid){post :create, {album: invalid_attributes, format: :json}}
    let(:req_create) {post :create, {album: valid_attributes.merge(user_id: subject.current_user.id, pins_attributes: [{image: file}]), format: :json}}

    context "when params valid" do
      it "will create new Album" do
        req_create
        res = jresponse
        expect(assigns(:album)).not_to be_nil
      end

      it "return 200 response" do
        req_create
        expect(response).to be_success
      end

      it "return valid json result" do
        req_create
        res = jresponse
        expect(res.keys).to contain_exactly("message","album","user", "api_key")
      end
    end

    context "when params invalid" do
      it "don't create new Album" do
        req_create_invalid
        expect(assigns(:album).id).to be_nil
      end

      it "return 422 response" do
        req_create_invalid
        expect(response.code.to_i).to eq(422)
      end
    end
  end

  describe "PUT #update" do

    before(:each) do
      @album = create_album
    end
    
    context "when params valid" do
      it "will success update album" do
        put :update, {album: FactoryGirl.attributes_for(:album).merge(title: "test_update"), id: @album.id, format: :json}

        expect(assigns(:album).title).to eq("test_update")
      end

      it "return 200 response" do
        put :update, {album: FactoryGirl.attributes_for(:album).merge(title: "test_update"), id: @album.id, format: :json}

        expect(response).to be_success
      end
    end

    context "when params invalid" do
      it "return 422 response" do
        album = create_album
        put :update, {album: invalid_attributes, id: album.id, format: :json}
        expect(response.code.to_i).to eq(422)
      end
    end
  end

  describe "DELETE #destroy" do

    it "destroy requested Album" do
      album = create_album
      expect {
        delete :destroy, {id: album.id, format: :json}
      }.to change(Album, :count).by(-1)
    end

    it "return 200 response" do
      album = create_album
      delete :destroy, {id: album.id, format: :json}
      expect(response).to be_success
    end
  end
end
