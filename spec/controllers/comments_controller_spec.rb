require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  login_user

  before(:each) do
    @album = Album.create!( FactoryGirl.attributes_for(:album).merge(user_id: controller.current_user.id, 
              pins_attributes: [{image: file, user_id: controller.current_user.id}]))
    @pin   = @album.pins.first
  end

  let(:file) { file = fixture_file_upload('/images/example1.jpg', 'image/jpeg')}
  let(:valid_attributes) { FactoryGirl.attributes_for(:comment).merge(pin_id: @pin.id, user_id: controller.current_user.id) }

  describe "POST #create" do
    context 'valid_attributes' do
      it "will save comment" do
        expect do
          post :create, :comment => valid_attributes, format: :json

        end.to change(Comment, :count).by(1)
      end

      it 'will return 201 http status' do
        post :create, :comment => valid_attributes , format: :json
        expect(response).to have_http_status(201)
      end
    end

    context 'valid_attributes' do
      it "will not save comment with blank text" do
        expect do
          post :create, :comment => valid_attributes.merge(text: ''), format: :json
        end.to change(Comment, :count).by(0)
      end

      it "will not save comment with blank pin_id" do
        expect do
          post :create, :comment => valid_attributes.merge(pin_id: nil), format: :json
        end.to change(Comment, :count).by(0)
      end

      it 'will return 422 http status' do
        post :create, :comment => {text: nil, pin_id: nil} , format: :json
        expect(response).to have_http_status(422)
      end

    end


  end



end

