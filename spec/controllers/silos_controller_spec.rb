require 'rails_helper'

RSpec.describe SilosController, type: :controller do

  describe 'GET #index' do
    let!(:silos) { [
      create(:silo, key: 'bbb'),
      create(:silo, key: 'ccc'),
      create(:silo, key: 'aaa'),
    ] }

    it 'returns a list of every silo' do
      get :index
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(response.body).to match_json_schema(:silos)
      expect(json.length).to eq(3)
    end

    it 'returns silos ordered by key alphabetically' do
      get :index
      json = JSON.parse(response.body)
      expect(json[0]['key']).to eq('aaa')
      expect(json[1]['key']).to eq('bbb')
      expect(json[2]['key']).to eq('ccc')
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
    let!(:user) { create(:user) }
    before { auth_headers(user) }
    let!(:release) { create(:release) }

    context 'with valid params' do
      let!(:params) {{ silo: {
        key: "  \n pr53 \t ",
        release_id: release.id,
      }}}

      it 'remove leading and trailing whitespace from the silo key' do
        post :create, params: params
        expect(assigns(:silo).key).to eq('pr53')
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

      it 'creates the expected Change record' do
        expect {
          post :create, params: params
        }.to change{ Change.count }.by(1)
        change = Change.latest_record
        expect(change.action).to eq('create')
        expect(change.target).to eq(assigns(:silo))
        expect(change.diff.keys).to include('key')
        expect(change.user).to eq(user)
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
        post :create, params: { silo: { key: 'f-o.o_', release_id: release.id }}
        expect(assigns(:silo)).to have_validation_error(:key, :invalid)
        expect(response.body).to match_json_schema(:errors)
      end

      it 'returns a validation error if the silo key is blank' do
        post :create, params: { silo: { key: " \t \n ", release_id: release.id }}
        expect(assigns(:silo)).to have_validation_error(:key, :blank)
        expect(response.body).to match_json_schema(:errors)
      end

      it 'returns a validation error if the release_id does not belong to a release' do
        post :create, params: { silo: { key: 'pr53', release_id: 666 }}
        expect(assigns(:silo)).to have_validation_error(:release, :blank)
        expect(response.body).to match_json_schema(:errors)
      end

      it 'does not create a Change record' do
        expect {
          post :create, params: { silo: { key: " \t \n " }}
        }.to_not change{ Change.count }
      end
    end
  end

  describe 'PUT #update' do
    let!(:user) { create(:user) }
    before { auth_headers(user) }
    let!(:silo) { create(:silo) }

    context 'with valid params' do

      it 'remove leading and trailing whitespace from the silo key' do
        expect {
          put :update, params: {
            id: silo.id,
            silo: { key: "  \n pr53 \t " }}
        }.to change{ silo.reload.key }.to('pr53')
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

      it 'creates the expected Change record' do
        expect {
          put :update, params: {
            id: silo.id,
            silo: { key: 'foo' }}
        }.to change{ Change.count }.by(1)
        change = Change.latest_record
        expect(change.action).to eq('update')
        expect(change.target).to eq(silo)
        expect(change.diff.keys).to include('key')
        expect(change.user).to eq(user)
      end
    end

    context 'with invalid params' do

      it 'does not update a silo' do
        expect {
          put :update, params: { id: silo.id, silo: { release_id: 666 }}
        }.to_not change{ silo.reload.attributes }
        expect(response.status).to eq(422)
      end

      it 'returns a validation error if the silo key already exists, case insensitive' do
        create(:silo, key: 'foo')
        put :update, params: { id: silo.id, silo: { key: ' FOO ' }}
        expect(assigns(:silo)).to have_validation_error(:key, :taken)
        expect(response.body).to match_json_schema(:errors)
      end

      it 'returns a validation error if the silo key contains invalid characters' do
        put :update, params: { id: silo.id, silo: { key: '!@#$%' }}
        expect(assigns(:silo)).to have_validation_error(:key, :invalid)
        expect(response.body).to match_json_schema(:errors)
      end

      it 'returns a validation error if the silo key is blank' do
        put :update, params: { id: silo.id, silo: { key: " \t \n " }}
        expect(assigns(:silo)).to have_validation_error(:key, :blank)
        expect(response.body).to match_json_schema(:errors)
      end

      it 'returns a validation error if the release_id does not belong to a release' do
        put :update, params: { id: silo.id, silo: { release_id: 666 }}
        expect(assigns(:silo)).to have_validation_error(:release, :blank)
        expect(response.body).to match_json_schema(:errors)
      end

      it 'does not create a Change record' do
        expect {
          put :update, params: { id: silo.id, silo: { release_id: 666 }}
        }.to_not change{ Change.count }
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    before { auth_headers(user) }
    let!(:silo) { create(:silo) }
    let!(:params) {{ id: silo.id }}

    it 'deletes the silo' do
      expect {
        delete :destroy, params: params
      }.to change{ Silo.count }.by(-1)
      expect { silo.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'does not delete any associated releases' do
      release = silo.release
      delete :destroy, params: params
      expect { release.reload }.to_not raise_error
    end

    it 'returns a success response with no body' do
      delete :destroy, params: params
      expect(response.status).to eq(204)
      expect(response.body).to be_blank
    end

    it 'creates the expected Change record' do
      expect {
        delete :destroy, params: params
      }.to change{ Change.count }.by(1)
      change = Change.latest_record
      expect(change.action).to eq('destroy')
      expect(change.target_id).to eq(silo.id)
      expect(change.target_type).to eq('Silo')
      expect(change.target_key).to eq(silo.key)
      expect(change.user).to eq(user)
    end
  end
end
