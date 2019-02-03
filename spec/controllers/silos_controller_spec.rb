require 'rails_helper'

RSpec.describe SilosController, type: :controller do

  describe 'GET #index' do
    let!(:silos) { create_list(:silo, 3) }

    it 'returns a list of every silo' do
      get :index
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(response.body).to match_json_schema(:silos)
      expect(json.length).to eq(3)
    end
  end

  describe 'GET #show' do
    let!(:silo) { create(:silo) }
    let!(:flags) { create_list(:flag, 3, release: silo.release) }
    let!(:params) {{ id: silo.id }}

    it 'returns a single silo and its release' do
      get :show, params: params
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(response.body).to match_json_schema(:silo)
      expect(json['key']).to eq(silo.key)
    end
  end

end
