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

  describe 'POST #create' do
    let!(:release) { create(:release) }

    context 'with valid params' do
      let!(:params) {{ silo: {
        key: "  \n release-4.20 \t ",
        release_id: release.id,
      }}}

      it 'remove leading and trailing whitespace from the silo key' do
        post :create, params: params
        expect(assigns(:silo).key).to eq('release-4.20')
      end

      it 'creates a new silo' do
        expect {
          post :create, params: params
        }.to change{ Silo.count }.by(1)
      end

      it 'returns the new silo' do
        post :create, params: params
        expect(response.status).to eq(201)
        expect(response.body).to match_json_schema(:silo)
      end
    end

    context 'with invalid params' do

      it 'does not create a silo' do
        expect {
          post :create, params: { silo: { key: '', release_id: release.id }}
        }.to_not change{ Silo.count }
        expect(response.status).to eq(422)
      end

      it 'returns a validation error if the silo key already exists, case insensitive' do
        create(:silo, key: 'foo')
        post :create, params: { silo: { key: ' FOO ', release_id: release.id }}
        expect(assigns(:silo)).to have_validation_error(:key, :taken)
        expect(response.body).to match_json_schema(:errors)
      end

      it 'returns a validation error if the silo key contains invalid characters' do
        post :create, params: { silo: { key: '!@#$%', release_id: release.id }}
        expect(assigns(:silo)).to have_validation_error(:key, :invalid)
        expect(response.body).to match_json_schema(:errors)
      end

      it 'returns a validation error if the silo key is blank' do
        post :create, params: { silo: { key: " \t \n ", release_id: release.id }}
        expect(assigns(:silo)).to have_validation_error(:key, :blank)
        expect(response.body).to match_json_schema(:errors)
      end

      it 'returns a validation error if the release_id does not belong to a release' do
        post :create, params: { silo: { key: 'release-4.20', release_id: 666 }}
        expect(assigns(:silo)).to have_validation_error(:release, :blank)
        expect(response.body).to match_json_schema(:errors)
      end
    end
  end

  describe 'PUT #update' do
    let!(:silo) { create(:silo) }

    context 'with valid params' do

      it 'remove leading and trailing whitespace from the silo key' do
        expect {
          put :update, params: {
            id: silo.id,
            silo: { key: "  \n release-4.20 \t " }}
        }.to change{ silo.reload.key }.to('release-4.20')
      end

      it 'allows the associated release to be changed' do
        release = create(:release)
        expect {
          put :update, params: {
            id: silo.id,
            silo: { release_id: release.id }}
        }.to change{ silo.reload.release }.to(release)
      end

      it 'returns the updated silo' do
        put :update, params: {
          id: silo.id,
          silo: { key: 'foo' }}
        expect(assigns(:silo)).to eq(silo)
        expect(response.status).to eq(200)
        expect(response.body).to match_json_schema(:silo)
      end
    end
  end
end
