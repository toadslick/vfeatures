require 'rails_helper'

RSpec.describe FlagsController, type: :controller do

  describe 'GET #show' do
    let!(:flag) { create(:flag) }
    let!(:params) {{ id: flag.id }}

    it 'returns a single flag' do
      get :show, params: params
      expect(response.status).to eq(200)
      expect(response.body).to match_json_schema(:flag)
      expect(assigns(:flag)).to eq(flag)
    end
  end

  describe 'PUT #update' do
    let!(:flag) { create(:flag) }

    context 'with valid params' do
      let!(:params) {{ id: flag.id, flag: { enabled: true }}}

      it 'updates the flag' do
        expect {
          put :update, params: params
        }.to change{ flag.reload.attributes }
      end

      it 'returns the updated flag' do
        put :update, params: params
        expect(assigns(:flag)).to eq(flag)
        expect(response.status).to eq(200)
        expect(response.body).to match_json_schema(:flag)
      end

      it 'creates the expected Change record' do
        expect {
          put :update, params: params
        }.to change{ Change.count }.by(1)
        change = Change.latest_record
        expect(change.action).to eq('update')
        expect(change.target).to eq(flag)
        expect(change.diff.keys).to include('enabled')
      end
    end

    context 'with unpermitted params' do

      it 'does not allow the associated feature to be changed' do
        params = { id: flag.id, flag: { feature_id: create(:feature).id }}
        expect {
          put :update, params: params
        }.to_not change{ flag.reload.attributes }
      end

      it 'does not allow the associated release to be changed' do
        params = { id: flag.id, flag: { release_id: create(:release).id }}
        expect {
          put :update, params: params
        }.to_not change{ flag.reload.attributes }
      end
    end
  end
end
