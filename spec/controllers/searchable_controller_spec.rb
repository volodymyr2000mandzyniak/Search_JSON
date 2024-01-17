# spec/controllers/searchable_controller_spec.rb
require 'rails_helper'

class SearchableController < ApplicationController
  include Searchable
end

RSpec.describe SearchableController, type: :controller do
  controller(described_class) do
    def index
      render plain: 'index'
    end
  end

  before do
    routes.draw { get 'index' => 'anonymous#index' }
  end

  it 'extracts positive and negative queries' do
    controller = described_class.new
    query = 'positive -negative'

    positive_query, negative_query = controller.send(:extract_queries, query)

    expect(positive_query).to include('positive')
    expect(negative_query).to match_array(['negative'])
  end

  describe '#filter_and_sort_results' do
    it 'filters and sorts results' do
      controller = described_class.new
      data = [
        { id: 1, name: 'apple' },
        { id: 2, name: 'banana' },
        { id: 3, name: 'orange' }
      ]
      controller.instance_variable_set(:@data, data)

      positive_query = ['apple']
      negative_query = []

      results = controller.send(:filter_and_sort_results, positive_query, negative_query)

      expect(results).to eq([{ id: 1, name: 'apple' }])
    end
  end

  describe 'matching methods' do
    let(:controller) { described_class.new }
    let(:item) { { name: 'apple' } }

    it 'checks positive match' do
      positive_query = ['apple']
      expect(controller.send(:positive_match?, item, positive_query)).to be_truthy
    end

    it 'checks negative match' do
      negative_query = ['orange']
      expect(controller.send(:negative_match?, item, negative_query)).to be_falsey
    end
  end

  it 'calculates relevance score' do
    controller = described_class.new
    item = { name: 'apple' }
    positive_query = ['apple']

    expect(controller.send(:relevance_score, item, positive_query)).to eq(1)
  end
end
