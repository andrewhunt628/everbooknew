require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  # since we don't testing token anymore and this test was passed in sessions controller rspec
  # we just always return this true. This is inside ControllerMacros
  authenticate_token_always_true

  login_user

  render_views

  before(:each) do
    @album = Album.create!( FactoryGirl.attributes_for(:album).merge(user_id: controller.current_user.id, 
              pins_attributes: [{image: file, user_id: controller.current_user.id}]))
    @pin   = @album.pins.first
  end

  let(:file) { file = fixture_file_upload('/images/example1.jpg', 'image/jpeg')}
  let(:valid_attributes) { FactoryGirl.attributes_for(:comment).merge(pin_id: @pin.id, user_id: controller.current_user.id) }

  describe "POST #create" do
    context "when params valid" do
      before(:each) do
        post :create, {comment: valid_attributes, format: :json}
      end

      it "will create comment" do
        expect(assigns(:comment).id).not_to be_nil
      end

      it "return 200 response" do
        expect(response).to be_success
      end

      it "get valid json" do
        res = jresponse
        expect(res.keys).to contain_exactly("user", "api_key", "message", "comment")
      end
    end

    context "when params invalid" do
      before(:each) do
        post :create, {comment: {text: nil}, format: :json}
      end

      it "will fails create comment" do
        expect(assigns(:comment).id).to be_nil
      end

      it "return 422 response" do
        expect(response.code.to_i).to eq(422)
      end
    end
  end
end
