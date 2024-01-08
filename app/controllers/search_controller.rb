class SearchController < ApplicationController
  # Викликається перед виконанням дій index та search для завантаження даних
  before_action :load_data, only: [:index, :search]

  # Дія для відображення початкової сторінки
  def index
    @total_data_count = @data.count
  end

  # Дія для пошуку даних за запитом користувача
  def search
    query = params[:query].to_s.downcase
    # Вибираємо дані, які відповідають запиту
    results = @data.select do |item|
      item.values.any? { |value| value.to_s.downcase.include?(query) }
    end

    # Виводимо результати у форматі JSON
    render json: results
  end

  private

  # Завантаження даних з файлу при виклику в before_action
  def load_data
    data_file_path = Rails.root.join('config', 'data', 'data.json')
    @data = JSON.parse(File.read(data_file_path))
  end
end
