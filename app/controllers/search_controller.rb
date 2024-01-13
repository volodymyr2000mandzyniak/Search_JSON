# Контролер для реалізації функціоналу пошуку та фільтрації даних.
class SearchController < ApplicationController
  # Включення модуля Searchable для спільного використання методів пошуку.
  include Searchable

  # Викликає метод load_data перед екшенами index та search.
  before_action :load_data, only: [:index, :search]

  # Екшен для відображення загальної кількості доступних даних на сторінці index.
  def index
    @total_data_count = @data.count
  end

  # Екшен для виконання пошуку та фільтрації даних за введеним користувачем запитом,
  # а також підготовка результатів для відправлення у форматі JSON.
  def search
    query = params[:query].to_s.downcase
    positive_query, negative_query = extract_queries(query)
    results = filter_and_sort_results(positive_query, negative_query)
    render json: results
  end

  private

  # Метод для завантаження даних з файлу перед викликом екшенів index та search.
  def load_data
    data_file_path = Rails.root.join('config', 'data', 'data.json')
    @data = JSON.parse(File.read(data_file_path))
  end
end
