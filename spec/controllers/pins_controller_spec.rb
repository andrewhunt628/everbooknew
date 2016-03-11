require 'rails_helper'

RSpec.describe PinsController, type: :controller do

  let(:expected_file_path) { "#{Rails.root}/public/system/pins/images/000/000/001/original/example1.jpg" }
  let(:file) { file = fixture_file_upload('/images/example1.jpg', 'image/jpeg') }
  let(:invalid_attr) {{image: nil, title: nil}}
  login_user

  describe "POST #create" do
    context "when params valid" do
      it "will save pin and this pin will have content_type equal 'image/jpeg' for example1.jpg" do
        post :create, :pin => {image: file} , format: :json
        pin = Pin.find(assigns(:pin).id) #get from database

        expect(pin.image.path).to eq("#{Rails.root}/public/system/pins/images/#{id_partition(pin.id)}/original/example1.jpg")
      end

      it 'will return 201 http status' do
        post :create, :pin => {image: file} , format: :json
        expect(response).to have_http_status(201)
      end
    end

    context "when params invalid" do
      before(:each) do
        post :create, {pin: invalid_attr}
      end
      
      it "will fails create Pin" do
        expect(assigns(:pin).id).to be_nil
      end

      it "and render action :new" do
        expect(response).to render_template("new")
      end
    end 

  end

  describe "PUT #update" do
    before(:each) do
      @pin = FactoryGirl.create(:pin)
    end

    context "when params valid" do
      before(:each) do
        put :update, {id: @pin, pin: {title: "update"}}
      end

      it "will update Pin" do
        expect(assigns(:pin).title).to eq("update")
      end

      it "and redirect to pins_path" do
        expect(response).to redirect_to pins_path
      end
    end

    context "when params invalid" do
      before(:each) do
        put :update, {id: @pin, pin: invalid_attr}
      end

      it "create instance @pin" do
        expect(assigns(:pin)).not_to be_nil
      end

      it "will render action :edit" do
        expect(response).to render_template("edit")
      end
    end
  end

  describe "GET #show" do
    context "when pin found" do
      before(:each) do
        @pin = FactoryGirl.create(:pin)
        get :show, {id: @pin.id}
      end

      it "create instance @pin" do
        expect(assigns(:pin)).not_to be_nil
      end

      it "will render show template" do
        expect(response).to render_template("show")
      end
    end

    context "when pin not found" do
      it "instance @pin nil" do
        expect(assigns(:pin)).to be_nil
      end
    end
  end

  describe "DELETE #destroy" do
    context "when pin found" do
      it "should destroy pin" do
        @pin = FactoryGirl.create(:pin)

        expect {
          delete :destroy, {id: @pin.id}
        }.to change(Pin, :count).by(-1)
      end
    end

    context "when pin not found" do
      it "raise ActiveRecord::RecordNotFound" do

        expect {
          delete :destroy, {id: 1}
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end


end

