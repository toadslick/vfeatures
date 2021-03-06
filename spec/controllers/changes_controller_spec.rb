require 'rails_helper'

RSpec.describe ChangesController, type: :controller do

  describe "GET #index" do
    before do
      allow(subject).to receive(:records_per_page) { 3 }
    end

    context 'with multiple pages of Change records' do
      let!(:changes) {[
        Timecop.freeze(3.days.ago) { create(:change) },
        Timecop.freeze(5.days.ago) { create(:change) },
        Timecop.freeze(2.days.ago) { create(:change) },
        Timecop.freeze(7.days.ago) { create(:change) },
        Timecop.freeze(4.days.ago) { create(:change) },
      ]}

      it 'returns a list of changes' do
        get :index
        expect(response.status).to eq(200)
        expect(response.body).to match_json_schema(:changes)
      end

      it 'returns the total count of matching results' do
        get :index
        json = JSON.parse(response.body)['pagination']
        expect(json['total']).to eq(5)
        expect(json['offset']).to eq(0)
      end

      it 'returns a single page of Change records' do
        get :index
        json = JSON.parse(response.body)['changes']
        expect(json.length).to eq(3)
        expect(assigns(:changes).length).to eq(3)
      end

      it 'returns Change records ordered by latest creation date' do
        get :index
        expect(assigns(:changes)[0]).to eq(changes[2])
        expect(assigns(:changes)[1]).to eq(changes[0])
        expect(assigns(:changes)[2]).to eq(changes[4])
      end

      context 'with valid page param' do
        let!(:params) {{ page: 1 }}

        it 'returns the given page of Change records' do
          get :index, params: params
          expect(assigns(:changes).length).to eq(2)
          expect(assigns(:changes)[0]).to eq(changes[1])
          expect(assigns(:changes)[1]).to eq(changes[3])
        end

        it 'returns the expected pagination info' do
          get :index, params: params
          json = JSON.parse(response.body)['pagination']
          expect(json['total']).to eq(5)
          expect(json['offset']).to eq(3)
        end
      end

      context 'with invalid page params' do
        let!(:params) {{ page: 'foo' }}

        it 'returns the first page of Change records' do
          get :index, params: params
          expect(assigns(:changes)[0]).to eq(changes[2])
          expect(assigns(:changes)[1]).to eq(changes[0])
          expect(assigns(:changes)[2]).to eq(changes[4])
        end
      end
    end

    context 'with valid target_type and target_id params' do
      let!(:silo) { create(:silo) }
      let!(:changes) {[
        create(:change),
        create(:change, target: silo),
        create(:change, target: silo),
        create(:change),
      ]}
      let!(:params) {{
        target_type: 'Silo',
        target_id: silo.id,
      }}

      it 'returns a page of Change records belonging to the target record' do
        get :index, params: params
        expect(assigns(:changes).length).to eq(2)
        expect(assigns(:changes)).to include(changes[1])
        expect(assigns(:changes)).to include(changes[2])
      end
    end

    context 'with invalid target_type or target_id params' do
      let!(:changes) { create_list(:change, 2) }
      let!(:params) {{
        target_type: 'foo',
        target_id: changes[0].target_id,
      }}

      it 'returns an empty set' do
        get :index, params: params
        expect(assigns(:changes)).to be_empty
      end
    end

    context 'with valid target_key param' do
      let!(:feature) { create(:feature) }
      let!(:changes) {[
        create(:change),
        create(:change, target_key: feature.key),
        create(:change),
        create(:change, target_key: feature.key),
        create(:change, target_key: feature.key),
      ]}
      let!(:params) {{
        target_key: feature.key,
      }}

      it 'returns a page of Change records with the given target_key' do
        get :index, params: params
        expect(assigns(:changes).length).to eq(3)
        expect(assigns(:changes)).to include(changes[1])
        expect(assigns(:changes)).to include(changes[3])
        expect(assigns(:changes)).to include(changes[4])
      end
    end

    context 'with invalid target_key param' do
      let!(:changes) { create_list(:change, 2) }
      let!(:params) {{
        target_key: 'not a thing',
      }}

      it 'returns an empty set' do
        get :index, params: params
        expect(assigns(:changes)).to be_empty
      end
    end

    context 'with valid user_id param' do
      let!(:user) { create(:user) }
      let!(:changes) {[
        create(:change),
        create(:change, user_id: user.id),
        create(:change),
        create(:change, user_id: user.id),
      ]}
      let!(:params) {{
        user_id: user.id,
      }}

      it 'returns a page of Change records with the given user_id' do
        get :index, params: params
        expect(assigns(:changes).length).to eq(2)
        expect(assigns(:changes)).to include(changes[1])
        expect(assigns(:changes)).to include(changes[3])
      end
    end

    context 'with invalid user_id param' do
      let!(:changes) { create_list(:change, 2) }
      let!(:params) {{
        user_id: 666,
      }}

      it 'returns an empty set' do
        get :index, params: params
        expect(assigns(:changes)).to be_empty
      end
    end

    context 'with valid action param' do
      let!(:changes) {[
        create(:change, target_action: 'create'),
        create(:change, target_action: 'update'),
        create(:change, target_action: 'create'),
        create(:change, target_action: 'destroy'),
      ]}
      let!(:params) {{
        target_action: 'create',
      }}

      it 'returns a page of Change records with the given user_id' do
        get :index, params: params
        expect(assigns(:changes).length).to eq(2)
        expect(assigns(:changes)).to include(changes[0])
        expect(assigns(:changes)).to include(changes[2])
      end
    end

    context 'with invalid target_action param' do
      let!(:changes) { create_list(:change, 2) }
      let!(:params) {{
        target_action: 'foo',
      }}

      it 'returns an empty set' do
        get :index, params: params
        expect(assigns(:changes)).to be_empty
      end
    end

    context 'when all params are combined' do
      let!(:release) { create(:release) }
      let!(:users) { create_list(:user, 2) }
      let!(:changes) {[
        *Timecop.freeze(1.days.ago) { create_list(:change, 3, target: release, target_key: 'foo') },
        *Timecop.freeze(7.days.ago) { create_list(:change, 3, target: release, target_key: release.key, user_id: users[0].id) },
        *Timecop.freeze(2.days.ago) { create_list(:change, 3, target: release, target_key: release.key, user_id: users[0].id) },
        *Timecop.freeze(3.days.ago) { create_list(:change, 3, target: release, target_key: release.key, user_id: users[0].id) },
        *Timecop.freeze(4.days.ago) { create_list(:change, 3, target: release, target_key: release.key, user_id: users[0].id) },
        *Timecop.freeze(2.days.ago) { create_list(:change, 3,                  target_key: release.key) },
        *Timecop.freeze(1.days.ago) { create_list(:change, 3, target: release, target_key: release.key, user_id: users[1].id) },
      ]}
      let!(:params) {{
        page: 1,
        target_id: release.id,
        target_type: 'Release',
        target_key: release.key,
        user_id: users[0].id,
      }}

      it 'returns the expected page of records' do
        get :index, params: params
        expect(assigns(:changes).length).to eq(3)
        expect(assigns(:pagination).total).to eq(12)
        expect(assigns(:changes)).to include(changes[9])
        expect(assigns(:changes)).to include(changes[10])
        expect(assigns(:changes)).to include(changes[11])
      end
    end
  end
end
