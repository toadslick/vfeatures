require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #index" do
    let!(:users) { create_list(:user, 3) }

    it 'returns a list of every user' do
      get :index
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(response.body).to match_json_schema(:users)
      expect(json.length).to eq(3)
    end
  end

end
