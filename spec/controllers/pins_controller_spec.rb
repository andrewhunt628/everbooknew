require 'rails_helper'

RSpec.describe PinsController, type: :controller do

  let(:expected_file_path) { "#{Rails.root}/public/system/pins/images/000/000/001/original/example1.jpg" }
  let(:file) { file = fixture_file_upload('/images/example1.jpg', 'image/jpeg') }
  login_user

  describe "POST #create" do
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
end

