require 'rails_helper'


RSpec.describe AlbumsController, type: :controller do

  let(:valid_attributes) { FactoryGirl.attributes_for(:album) }
  
  let(:file) { file = fixture_file_upload('/images/example1.jpg', 'image/jpeg') }

  let(:create_album) do
    Album.create! valid_attributes.merge(user_id: controller.current_user.id, pins_attributes: [{image: file}])
  end
  
  let(:invalid_attributes) do
    {
      title: nil,
      description: nil
    }
  end

  let(:valid_session) { {} }

  login_user

  describe "GET #index" do
    it "assigns all albums as @albums" do
      album = create_album  
      get :index, {}, valid_session
      expect(assigns(:albums)).to eq([album])
    end
  end


  describe "GET #new" do
    it "assigns a new album as @album" do
      get :new, {}, valid_session
      expect(assigns(:album)).to be_a_new(Album)
    end
  end

  describe "GET #edit" do
    it "assigns the requested album as @album" do
      album = create_album
      get :edit, {:id => album.to_param}, valid_session
      expect(assigns(:album)).to eq(album)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Album" do
        expect {
          post :create, {:album => valid_attributes.merge(user_id: controller.current_user.id, pins_attributes: [{image: file}])}, valid_session
        }.to change(Album, :count).by(1)
      end

      it "assigns a newly created album as @album" do
        post :create, {:album => valid_attributes.merge(user_id: controller.current_user.id, pins_attributes: [{image: file}])}, 
          valid_session
        expect(assigns(:album)).to be_a(Album).and be_persisted
      end

      it "redirects to the created album" do
        post :create, {:album => valid_attributes.merge(user_id: controller.current_user.id, pins_attributes: [{image: file}])}, valid_session
        expect(response).to redirect_to(Album.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved album as @album" do
        post :create, {:album => invalid_attributes}, valid_session
        expect(assigns(:album)).to be_a_new(Album)
      end

      it "re-renders the 'new' template" do
        post :create, {:album => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        FactoryGirl.attributes_for(:album)
      }

      it "updates the requested album" do
        album_was = create_album
        put :update, {:id => album_was.to_param, :album => new_attributes}, valid_session
        album = Album.find(album_was)
        expect(album.attributes).to_not eq(album_was.attributes)
      end

      it "assigns the requested album as @album" do
        album = create_album
        put :update, {:id => album.to_param, :album => valid_attributes}, valid_session
        expect(assigns(:album)).to eq(album)
      end

      it "redirects to the album" do
        album = create_album
        put :update, {:id => album.to_param, :album => valid_attributes}, valid_session
        expect(response).to redirect_to(album)
      end
    end

    context "with invalid params" do
      it "assigns the album as @album" do
        album = create_album
        put :update, {:id => album.to_param, :album => invalid_attributes}, valid_session
        expect(assigns(:album)).to eq(album)
      end

      it "re-renders the 'edit' template" do
        album = create_album
        put :update, {:id => album.to_param, :album => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested album" do
      album = create_album
      expect {
        delete :destroy, {:id => album.to_param}, valid_session
      }.to change(Album, :count).by(-1)
    end

    it "redirects to the albums list" do
      album = create_album
      delete :destroy, {:id => album.to_param}, valid_session
      expect(response).to redirect_to(albums_url)
    end
  end

end
