# require 'rails_helper'
#
# RSpec.describe SilosController, type: :controller do
#
#   describe 'GET #index' do
#     let!(:silos) { create_list(:silo, 3) }
#
#     it 'returns a list of every feature' do
#       get :index
#       expect(response.status).to eq(200)
#       expect(response.body).to match_json_schema(:features)
#     end
#   end
#
#   describe 'GET #show' do
#     let!(:feature) { create(:feature) }
#     let!(:flags) { create_list(:flag, 3, feature: feature) }
#     let!(:params) {{ id: feature.id }}
#
#     it 'returns a single feature and its flags for every release' do
#       get :show, params: params
#       json = JSON.parse(response.body)
#       expect(response.status).to eq(200)
#       expect(response.body).to match_json_schema(:feature)
#       expect(json['flags'].length).to eq(3)
#     end
#   end
#   #
#   # describe 'POST #create' do
#   #   context 'with valid params' do
#   #     let!(:params) {{ feature: { key: "  \n foo \t " }}}
#   #
#   #     it 'remove leading and trailing whitespace from the feature key' do
#   #       post :create, params: params
#   #       expect(assigns(:feature).key).to eq('foo')
#   #     end
#   #
#   #     it 'creates a new feature' do
#   #       expect {
#   #         post :create, params: params
#   #       }.to change{ Feature.count }.by(1)
#   #     end
#   #
#   #     it 'creates an associated flag that is disabled for every release' do
#   #       releases = create_list(:release, 3)
#   #       expect {
#   #         post :create, params: params
#   #       }.to change{ Flag.count }.by(3)
#   #       expect(assigns(:feature).flags.length).to eq(3)
#   #     end
#   #
#   #     it 'returns the new feature' do
#   #       post :create, params: params
#   #       expect(response.status).to eq(201)
#   #       expect(response.body).to match_json_schema(:feature)
#   #     end
#   #   end
#   #
#   #   context 'with invalid params' do
#   #
#   #     it 'does not create a feature' do
#   #       expect {
#   #         post :create, params: { feature: { key: '' }}
#   #       }.to_not change{ Feature.count }
#   #       expect(response.status).to eq(422)
#   #     end
#   #
#   #     it 'does not create any flags' do
#   #       expect {
#   #         post :create, params: { feature: { key: '' }}
#   #       }.to_not change{ Flag.count }
#   #       expect(response.status).to eq(422)
#   #     end
#   #
#   #     it 'returns a validation error if the feature key already exists, case insensitive' do
#   #       create(:feature, key: 'foo')
#   #       post :create, params: { feature: { key: 'FOO' }}
#   #       expect(assigns(:feature)).to have_validation_error(:key, :taken)
#   #       expect(response.body).to match_json_schema(:errors)
#   #     end
#   #
#   #     it 'returns a validation error if the feature key contains any non-alphanumeric characters' do
#   #       post :create, params: { feature: { key: ' f o o ' }}
#   #       expect(assigns(:feature)).to have_validation_error(:key, :invalid)
#   #       expect(response.body).to match_json_schema(:errors)
#   #     end
#   #
#   #     it 'returns a validation error if the feature key is blank' do
#   #       post :create, params: { feature: { key: " \t \n " }}
#   #       expect(assigns(:feature)).to have_validation_error(:key, :blank)
#   #       expect(response.body).to match_json_schema(:errors)
#   #     end
#   #   end
#   # end
#   #
#   # describe 'PUT #update' do
#   #   let!(:feature) { create(:feature) }
#   #
#   #   context 'with valid params' do
#   #     let!(:params) {{
#   #       id: feature.id,
#   #       feature: {
#   #         key: "  \n foo \t ",
#   #       }
#   #     }}
#   #
#   #     it 'remove leading and trailing whitespace from the feature key' do
#   #       expect {
#   #         put :update, params: params
#   #       }.to change{ feature.reload.key }.to('foo')
#   #     end
#   #
#   #     it 'returns the updated feature' do
#   #       put :update, params: params
#   #       expect(assigns(:feature)).to eq(feature)
#   #       expect(response.status).to eq(200)
#   #       expect(response.body).to match_json_schema(:feature)
#   #     end
#   #   end
#   #
#   #   context 'with valid params for associated flags' do
#   #     let!(:flags) { create_list(:flag, 3, feature: feature) }
#   #     let!(:params) {{
#   #       id: feature.id,
#   #       feature: {
#   #         flags_attributes: [
#   #           { id: flags[0].id, enabled: true },
#   #           { id: flags[2].id, enabled: true },
#   #         ]} }}
#   #
#   #     it 'updates the enabled state of any flags' do
#   #       put :update, params: params
#   #       expect(flags[0].reload).to be_enabled
#   #       expect(flags[1].reload).to_not be_enabled
#   #       expect(flags[2].reload).to be_enabled
#   #     end
#   #   end
#   #
#   #   context 'with invalid params for associated flags' do
#   #     let!(:flags) { create_list(:flag, 3, feature: feature) }
#   #
#   #     it 'does not create new flags if an id is omitted' do
#   #       params = {
#   #         id: feature.id,
#   #         feature: {
#   #           flags_attributes: [{
#   #             enabled: true
#   #           }] }}
#   #       expect {
#   #         put :update, params: params
#   #       }.to_not change{ Flag.count }
#   #     end
#   #
#   #     it 'does not update flags that belong to a different feature' do
#   #       unrelated_flag = create(:flag)
#   #       params = {
#   #         id: feature.id,
#   #         feature: {
#   #           flags_attributes: [{
#   #             id: unrelated_flag.id,
#   #             enabled: true
#   #           }] }}
#   #       expect {
#   #         put :update, params: params
#   #       }.to_not change{ unrelated_flag.reload.attributes }
#   #     end
#   #
#   #     it 'does not update the associated release for any flag' do
#   #       params = {
#   #         id: feature.id,
#   #         feature: {
#   #           flags_attributes: [{
#   #             id: flags[0].id,
#   #             release_id: create(:release).id
#   #           }] }}
#   #       expect {
#   #         put :update, params: params
#   #       }.to_not change{ flags[0].reload.attributes }
#   #     end
#   #   end
#   #
#   #   context 'with invalid params' do
#   #
#   #     it 'does not update the feature' do
#   #       params = {
#   #         id: feature.id,
#   #         feature: { key: '  ' }}
#   #       expect {
#   #         put :update, params: params
#   #       }.to_not change{ feature.reload.attributes }
#   #       expect(response.status).to eq(422)
#   #     end
#   #
#   #     it 'does not update any associated flags' do
#   #       flag = create(:flag, { feature: feature })
#   #       params = {
#   #         id: feature.id,
#   #         feature: {
#   #           key: '  ',
#   #           flags_attributes: [{
#   #             id: flag.id,
#   #             enabled: true
#   #           }] }}
#   #       expect {
#   #         put :update, params: params
#   #       }.to_not change{ flag.reload.attributes }
#   #       expect(response.status).to eq(422)
#   #     end
#   #
#   #     it 'returns a validation error if the feature key already exists, case insensitive' do
#   #       create(:feature, key: 'foo')
#   #       put :update, params: {
#   #         id: feature.id,
#   #         feature: { key: 'FOO' }}
#   #       expect(assigns(:feature)).to have_validation_error(:key, :taken)
#   #       expect(response.body).to match_json_schema(:errors)
#   #     end
#   #
#   #     it 'returns a validation error if the feature key contains any non-alphanumeric characters' do
#   #       put :update, params: {
#   #         id: feature.id,
#   #         feature: { key: ' f o o ' }}
#   #       expect(assigns(:feature)).to have_validation_error(:key, :invalid)
#   #       expect(response.body).to match_json_schema(:errors)
#   #     end
#   #
#   #     it 'returns a validation error if the feature key is blank' do
#   #       put :update, params: {
#   #         id: feature.id,
#   #         feature: { key: " \t \n " }}
#   #       expect(assigns(:feature)).to have_validation_error(:key, :blank)
#   #       expect(response.body).to match_json_schema(:errors)
#   #     end
#   #
#   #   end
#   # end
#   #
#   # describe 'DELETE #destroy' do
#   #   let!(:feature) { create(:feature) }
#   #   let!(:flags) { create_list(:flag, 3, feature: feature) }
#   #   let!(:params) {{ id: feature.id }}
#   #
#   #   it 'deletes the feature' do
#   #     expect {
#   #       delete :destroy, params: params
#   #     }.to change{ Feature.count }.by(-1)
#   #   end
#   #
#   #   it 'does not delete unrelated flags' do
#   #     unrelated_flag = create(:flag)
#   #     delete :destroy, params: params
#   #     expect { unrelated_flag.reload }.to_not raise_error
#   #   end
#   #
#   #   it 'does not delete any associated releases' do
#   #     expect {
#   #       delete :destroy, params: params
#   #     }.to_not change{ Release.count }
#   #   end
#   #
#   #   it 'returns a success response with no body' do
#   #     delete :destroy, params: params
#   #     expect(response.status).to eq(200)
#   #     expect(response.body).to be_blank
#   #   end
#   # end
#
#
# end
