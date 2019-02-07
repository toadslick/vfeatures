require 'rails_helper'

RSpec.describe ChangesController, type: :controller do

  describe "GET #index" do
    before do
      allow(subject).to receive(:records_per_page) { 3 }
    end

    context 'with multiple pages of Change records' do
      let!(:changes) {[
        create(:change, created_at: 3.days.ago),
        create(:change, created_at: 5.days.ago),
        create(:change, created_at: 2.days.ago),
        create(:change, created_at: 7.days.ago),
        create(:change, created_at: 4.days.ago),
      ]}

      it 'returns a list of changes' do
        get :index
        expect(response.status).to eq(200)
        expect(response.body).to match_json_schema(:changes)
      end

      it 'returns the total count of matching results' do
        get :index
        json = JSON.parse(response.body)
        expect(json[:total]).to eq(5)
        expect(assigns[:count]).to eq(5)
      end

      it 'returns a single page of Change records' do
        get :index
        json = JSON.parse(response.body)
        expect(json[:changes].length).to eq(3)
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
          get :index, params
          expect(assigns(:changes).length).to eq(2)
          expect(assigns(:changes)[0]).to eq(changes[1])
          expect(assigns(:changes)[1]).to eq(changes[3])
        end
      end

      context 'with invalid page params' do
        let!(:params) {{ page: 'foo' }}

        it 'returns the first page of Change records' do
          get :index, params
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
        get :index, params
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
        get :index, params
        expect(assigns(:changes)).to be_empty
      end
    end

    context 'with valid target_key param' do

      it 'returns a page of Change records with the given target_key' do

      end
    end

    context 'with invalid target_key param' do

      it 'returns an empty set' do

      end
    end


    it 'returns the expected records when all params are combined' do

    end
  end
end
