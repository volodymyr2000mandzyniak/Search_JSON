class SearchController < ApplicationController
  before_action :load_data, only: [:index, :search]

  def index
    @total_data_count = @data.count
  end

  def search
    query = params[:query].to_s.downcase
    positive_query, negative_query = extract_queries(query)

    # Фільтрація результатів за позитивним і негативним запитами
    results = @data.select do |item|
      positive_match = positive_match?(item, positive_query)
      negative_match = negative_match?(item, negative_query)

      positive_match && !negative_match
    end

    # Сортування результатів за релевантністю (кількістю збігів)
    sorted_results = results.sort_by { |item| relevance_score(item, positive_query) }.reverse

    render json: sorted_results
  end

  private

  # Завантаження даних з файлу при виклику в before_action
  def load_data
    data_file_path = Rails.root.join('config', 'data', 'data.json')
    @data = JSON.parse(File.read(data_file_path))
  end

  # Виділення позитивних та негативних запитів
  def extract_queries(query)
    positive_query = query.scan(/\w+/)
    negative_query = query.scan(/-(\w+)/).flatten
    [positive_query, negative_query]
  end

  # Перевірка збігу за позитивним запитом
  def positive_match?(item, positive_query)
    positive_query.all? do |pos_word|
      if pos_word.include?(' ')
        subwords = pos_word.split(' ')
        subwords.any? { |subword| item.values.any? { |value| value.to_s.downcase.include?(subword) } }
      else
        item.values.any? { |value| value.to_s.downcase.include?(pos_word) }
      end
    end
  end

  # Перевірка збігу за негативним запитом
  def negative_match?(item, negative_query)
    negative_query.any? do |neg_word|
      item.values.any? { |value| value.to_s.downcase.include?(neg_word) }
    end
  end

  # Оцінка релевантності (кількість збігів) для сортування результатів
  def relevance_score(item, positive_query)
    positive_query.count do |pos_word|
      if pos_word.include?(' ')
        subwords = pos_word.split(' ')
        subwords.any? { |subword| item.values.any? { |value| value.to_s.downcase.include?(subword) } }
      else
        item.values.any? { |value| value.to_s.downcase.include?(pos_word) }
      end
    end
  end
end
