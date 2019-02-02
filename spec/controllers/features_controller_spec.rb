require 'rails_helper'

RSpec.describe FeaturesController, type: :controller do

  describe 'GET #index' do
    let!(:features) { create_list(:feature, 3) }

    it 'returns a list of every feature' do
      get :index
      expect(response.status).to eq(200)
      expect(response.body).to match_json_schema(:features)
    end
  end

  describe 'GET #show' do
    let!(:feature) { create(:feature) }
    let!(:flags) { create_list(:flag, 3, feature: feature) }

    it 'returns a single feature and its flags for every release' do
      get :show, params: { id: feature.id }
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(response.body).to match_json_schema(:feature)
      expect(json['flags'].length).to eq(3)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'remove leading and trailing whitespace from the feature key' do

      end
      it 'creates a new feature' do

      end
      it 'creates an associated flag that is disabled for every release' do

      end
      it 'returns the new feature' do

      end
    end

    context 'with invalid params' do
      it 'does not create a feature or any flags or silos' do

      end
      it 'returns a validation error if the feature key already exists' do

      end
      it 'returns a validation error if the feature key contains any non-alphanumeric characters' do

      end
      it 'returns a validation error if the feature key is blank' do

      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do

      it 'remove leading and trailing whitespace from the feature key' do

      end
      it 'updates the feature key' do

      end
      it 'returns the updated feature' do

      end
    end

    context 'with invalid params' do
      it 'does not update the feature' do

      end
      it 'returns a validation error if the feature key already exists' do

      end
      it 'returns a validation error if the feature key contains any non-alphanumeric characters' do

      end
      it 'returns a validation error if the feature key is blank' do

      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the feature' do

    end
    it 'deletes the associated flag for every silo' do

    end
    it 'returns a success response with no body' do

    end
  end
end
