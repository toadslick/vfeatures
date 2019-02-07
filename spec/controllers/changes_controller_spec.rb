require 'rails_helper'

RSpec.describe ChangesController, type: :controller do

  describe "GET #index" do

    it 'returns a list of changes' do
      get :index
      expect(response.status).to eq(200)
      expect(response.body).to match_json_schema(:changes)
    end

    it 'returns the total count of matching results' do

    end

    it 'returns a single page of records' do

    end

    it 'returns the records ordered by latest creation date' do

    end

    it 'with valid page param' do

      it 'returns the given page of records' do

      end
    end

    it 'with invalid page params' do

      it 'returns the first page of records' do

      end
    end

    it 'with valid target_type and target_id params' do

      it 'returns only changes associated with the target record' do

      end
    end

    it 'with invalid target_type or target_id params' do

      it 'returns an empty set' do

      end
    end

    it 'returns the expected records when all params are combined' do
      
    end
  end
end
