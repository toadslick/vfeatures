require 'rails_helper'

RSpec.describe ReleasesController, type: :controller do

  describe 'GET #index' do
    let!(:releases) { create_list(:release, 3) }

    it 'returns a list of every release' do
      get :index
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(response.body).to match_json_schema(:releases)
      expect(json.length).to eq(3)
    end
  end

  describe 'GET #show' do
    let!(:release) { create(:release) }
    let!(:flags) { create_list(:flag, 3, release: release) }
    let!(:params) {{ id: release.id }}

    it 'returns a single release and its flags for every feature' do
      get :show, params: params
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(response.body).to match_json_schema(:release)
      expect(json['flags'].length).to eq(3)
    end
  end

  describe 'POST #create' do
    let!(:user) { create(:user) }
    before { auth_headers(user) }

    context 'with valid params' do
      let!(:params) {{ release: { key: "  \n release-4.20 \t " }}}

      it 'remove leading and trailing whitespace from the release key' do
        post :create, params: params
        expect(assigns(:release).key).to eq('release-4.20')
      end

      it 'creates a new release' do
        expect {
          post :create, params: params
        }.to change{ Release.count }.by(1)
      end

      it 'creates an associated flag that is disabled for every feature' do
        features = create_list(:feature, 3)
        expect {
          post :create, params: params
        }.to change{ Flag.count }.by(3)
        expect(assigns(:release).flags.length).to eq(3)
      end

      it 'returns the new release' do
        post :create, params: params
        expect(response.status).to eq(201)
        expect(response.body).to match_json_schema(:release)
      end

      it 'creates the expected Change record' do
        expect {
          post :create, params: params
        }.to change{ Change.count }.by(1)
        change = Change.latest_record
        expect(change.action).to eq('create')
        expect(change.target).to eq(assigns(:release))
        expect(change.diff.keys).to include('key')
        expect(change.user).to eq(user)
      end
    end

    context 'with invalid params' do

      it 'does not create a release' do
        expect {
          post :create, params: { release: { key: '' }}
        }.to_not change{ Release.count }
        expect(response.status).to eq(422)
      end

      it 'does not create any flags' do
        features = create_list(:feature, 3)
        expect {
          post :create, params: { release: { key: '' }}
        }.to_not change{ Flag.count }
        expect(response.status).to eq(422)
      end

      it 'returns a validation error if the release key already exists, case insensitive' do
        create(:release, key: 'release-4.20')
        post :create, params: { release: { key: "\t RELEASE-4.20 \n" }}
        expect(assigns(:release)).to have_validation_error(:key, :taken)
        expect(response.body).to match_json_schema(:errors)
      end

      it 'returns a validation error if the release key contains any invalid characters' do
        post :create, params: { release: { key: '!@#$%' }}
        expect(assigns(:release)).to have_validation_error(:key, :invalid)
        expect(response.body).to match_json_schema(:errors)
      end

      it 'returns a validation error if the release key is blank' do
        post :create, params: { release: { key: " \t \n " }}
        expect(assigns(:release)).to have_validation_error(:key, :blank)
        expect(response.body).to match_json_schema(:errors)
      end

      it 'does not create a Change record' do
        expect {
          post :create, params: { release: { key: " \t \n " }}
        }.to_not change{ Change.count }
      end
    end
  end

  describe 'PUT #update' do
    let!(:user) { create(:user) }
    before { auth_headers(user) }
    let!(:release) { create(:release) }

    context 'with valid params' do
      let!(:params) {{
        id: release.id,
        release: {
          key: "  \n release-4.20 \t ",
        }
      }}

      it 'remove leading and trailing whitespace from the release key' do
        expect {
          put :update, params: params
        }.to change{ release.reload.key }.to('release-4.20')
      end

      it 'returns the updated release' do
        put :update, params: params
        expect(assigns(:release)).to eq(release)
        expect(response.status).to eq(200)
        expect(response.body).to match_json_schema(:release)
      end

      it 'creates the expected Change record' do
        expect {
          put :update, params: params
        }.to change{ Change.count }.by(1)
        change = Change.latest_record
        expect(change.action).to eq('update')
        expect(change.target).to eq(release)
        expect(change.diff.keys).to include('key')
        expect(change.user).to eq(user)
      end
    end

    context 'with invalid params' do

      it 'does not update the release' do
        params = {
          id: release.id,
          release: { key: '  ' }}
        expect {
          put :update, params: params
        }.to_not change{ release.reload.attributes }
        expect(response.status).to eq(422)
      end

      it 'does not update any associated flags' do
        flag = create(:flag, release: release)
        params = {
          id: release.id,
          release: {
            key: '  ',
            flags_attributes: [{
              id: flag.id,
              enabled: true
            }] }}
        expect {
          put :update, params: params
        }.to_not change{ flag.reload.attributes }
        expect(response.status).to eq(422)
      end

      it 'returns a validation error if the release key already exists, case insensitive' do
        create(:release, key: 'foo')
        put :update, params: {
          id: release.id,
          release: { key: 'FOO' }}
        expect(assigns(:release)).to have_validation_error(:key, :taken)
        expect(response.body).to match_json_schema(:errors)
      end

      it 'returns a validation error if the release key contains any non-alphanumeric characters' do
        put :update, params: {
          id: release.id,
          release: { key: ' f o o ' }}
        expect(assigns(:release)).to have_validation_error(:key, :invalid)
        expect(response.body).to match_json_schema(:errors)
      end

      it 'returns a validation error if the release key is blank' do
        put :update, params: {
          id: release.id,
          release: { key: " \t \n " }}
        expect(assigns(:release)).to have_validation_error(:key, :blank)
        expect(response.body).to match_json_schema(:errors)
      end

      it 'does not create a Change record' do
        expect {
          put :update, params: {
            id: release.id,
            release: { key: " \t \n " }}
        }.to_not change{ Change.count }
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    before { auth_headers(user) }

    let!(:release) { create(:release) }
    let!(:params) {{ id: release.id }}

    it 'deletes the release' do
      expect {
        delete :destroy, params: params
      }.to change{ Release.count }.by(-1)
    end

    it 'deletes the associated flag for every feature' do
      create_list(:flag, 3, release: release)
      expect {
        delete :destroy, params: params
      }.to change{ Flag.count }.by(-3)
    end

    it 'does not delete unrelated flags' do
      unrelated_flag = create(:flag)
      delete :destroy, params: params
      expect { unrelated_flag.reload }.to_not raise_error
    end

    it 'does not delete any associated features' do
      expect {
        delete :destroy, params: params
      }.to_not change{ Feature.count }
    end

    it 'returns a success response with no body' do
      delete :destroy, params: params
      expect(response.status).to eq(200)
      expect(response.body).to be_blank
    end

    it 'creates the expected Change record' do
      expect {
        delete :destroy, params: params
      }.to change{ Change.count }.by(1)
      change = Change.latest_record
      expect(change.action).to eq('destroy')
      expect(change.target_id).to eq(release.id)
      expect(change.target_type).to eq('Release')
      expect(change.target_key).to eq(release.key)
      expect(change.user).to eq(user)
    end
  end
end
