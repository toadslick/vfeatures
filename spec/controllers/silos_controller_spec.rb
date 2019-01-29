require 'rails_helper'

RSpec.describe SilosController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    let(:silo) { create :silo }

    it "returns http success" do
      get :show, params: { id: silo.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "returns http success" do
      post :create
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT #update" do
    let(:silo) { create :silo }

    it "returns http success" do
      put :update, params: { id: silo.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE #destroy" do
    let(:silo) { create :silo }

    it "returns http success" do
      delete :destroy, params: { id: silo.id }
      expect(response).to have_http_status(:success)
    end
  end

end
