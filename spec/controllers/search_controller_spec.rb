# spec/controllers/search_controller_spec.rb
require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    it 'assigns total_data_count' do
      get :index
      expect(assigns(:total_data_count)).to be_present
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET #search' do
    it 'returns JSON response with search results' do
      mock_data = [{ "name" => "Test Item" }]
      allow(File).to receive(:read).and_return(JSON.generate(mock_data))

      allow(controller).to receive(:extract_queries).and_call_original
      allow(controller).to receive(:filter_and_sort_results).and_call_original

      get :search, params: { query: 'test' }

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
    end
  end
end
