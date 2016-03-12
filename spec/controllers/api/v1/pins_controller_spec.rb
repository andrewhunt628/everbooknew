require 'rails_helper'

RSpec.describe Api::V1::PinsController, type: :controller do
  # since we don't testing token anymore and this test was passed in sessions controller rspec
  # we just always return this true. This is inside ControllerMacros
  authenticate_token_always_true

  login_user
  # make sure jbuilder is rendered to get json result
  render_views

  let(:expected_file_path) { "#{Rails.root}/public/system/pins/images/000/000/001/original/example1.jpg" }
  let(:file) { file = fixture_file_upload('/images/example1.jpg', 'image/jpeg') }
  let(:create_pin) {FactoryGirl.create(:pin)}
  let(:valid_attr) { {image: file, title: "test"}}
  let(:invalid_attr) {{image: nil, title: nil}}

  describe "GET #index" do
    let(:req_index) {get :index, format: :json}
    before(:each) do
      @pin = create_pin
      req_index
      @res = jresponse
    end

    it "@pins and" do
      expect(assigns(:pins)).not_to be_nil 
    end

    it "@tags must exists" do
      expect(assigns(:tags)).not_to be_nil 
    end

    it "and return valid json" do
      expect(@res.keys).to contain_exactly("pins", "user", "tags", "api_key")
    end

    it "return 200 response" do
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    before(:each) do
      @pin = create_pin 
      get :show, {format: :json, id: @pin.id}
    end

    it "create instances @pin" do
      expect(assigns(:pin)).not_to be_nil
    end

    it "and return 200 response" do
      expect(response).to be_success
    end
  end

  describe "PUT #update" do
    before(:each) do
      @pin = create_pin
    end

    context "when params valid" do
      before(:each) do
        put :update, {id: @pin.id, pin: {title: "baru"}, format: :json}
      end

      it "will create instance @pin" do
        expect(assigns(:pin)).not_to be_nil
      end

      it "update record" do
        expect(assigns(:pin).title).to eq("baru")
      end

      it "return 200 response" do
        expect(response).to be_success
      end

      it "and get valid json" do
        res = jresponse
        expect(res.keys).to contain_exactly("message", "user", "api_key", "pin")
      end
    end

    context "when params invalid" do
      it "return 422 response" do
        put :update, {id: @pin.id, pin: invalid_attr, format: :json}
        expect(response.code.to_i).to eq(422)
      end
    end

  end

  describe "POST #create" do

    context "when params valid" do

      before(:each) do
        post :create, {pin: valid_attr, format: :json}
      end

      it "will create instance @pin" do
        expect(assigns(:pin).id).not_to be_nil
      end

      it "return 200 response" do
        expect(response).to be_success
      end

      it "and return valid json" do
        res = jresponse
        expect(res.keys).to contain_exactly("message", "user", "api_key", "pin")
      end
    end

    context "when params invalid" do
      it "return 422 response" do
        post :create, {pin: invalid_attr, format: :json}
        expect(response.code.to_i).to eq(422)
      end
    end
  end


  describe "DELETE #destroy" do
      
    context "when pin found" do
      before(:each) do
        @pin = create_pin
      end

      it "will destroy pin" do
        expect {
          delete :destroy, {id: @pin, format: :json}
        }.to change(Pin, :count).by(-1)
      end

      it "return 200 response" do
        delete :destroy, {id: @pin.id, format: :json}
        expect(response).to be_success
      end
    end

    context "when get response 404" do
      it "will raise ActiveRecord::RecordNotFound" do
        delete :destroy, {id: 1, format: :json}
        expect(response.code.to_i).to eq(404)
        # expect {
        #   delete :destroy, {id: 1, format: :json}
        # }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
