# Модуль, який додає функціонал для пошуку та фільтрації даних.
module Searchable
  extend ActiveSupport::Concern

  private

  # Метод для виділення позитивних та негативних запитів з користувацького запиту.
  def extract_queries(query)
    positive_query = query.scan(/\b(\w+)\b/).flatten
    negative_query = query.scan(/-(\w+)/).flatten
    [positive_query, negative_query]
  end

  # Метод для фільтрації та сортування результатів за позитивними та негативними запитами.
  def filter_and_sort_results(positive_query, negative_query)
    exact_match_results = @data.select do |item|
      positive_match?(item, positive_query) && !negative_match?(item, negative_query)
    end.select { |item| item.values.any? { |value| value.to_s.downcase.start_with?(positive_query.first) } }

    partial_match_results = @data.select do |item|
      positive_match?(item, positive_query) && !negative_match?(item, negative_query)
    end.reject { |item| item.values.any? { |value| value.to_s.downcase.start_with?(positive_query.first) } }

    exact_match_results.sort_by { |item| relevance_score(item, positive_query) }.reverse +
      partial_match_results.sort_by { |item| relevance_score(item, positive_query) }.reverse
  end

  # Метод для перевірки збігу за позитивним запитом.
  def positive_match?(item, positive_query)
    positive_query.all? do |pos_word|
      regex = Regexp.new(Regexp.escape(pos_word), Regexp::IGNORECASE)
      subwords = pos_word.split(' ')

      if subwords.size > 1
        subwords.all? do |subword|
          item.values.any? { |value| value.to_s.downcase =~ /\b#{Regexp.escape(subword)}\b/ }
        end
      else
        item.values.any? { |value| value.to_s.downcase =~ regex }
      end
    end
  end

  # Метод для перевірки збігу за негативним запитом.
  def negative_match?(item, negative_query)
    negative_query.any? do |neg_word|
      item.values.none? { |value| value.to_s.downcase.include?(neg_word) }
    end
  end

  # Метод для оцінки релевантності (кількість збігів) для сортування результатів.
  def relevance_score(item, positive_query)
    relevance_scores = positive_query.map do |pos_word|
      if pos_word.include?(' ')
        subwords = pos_word.split(' ')
        subwords.count do |subword|
          item.values.any? { |value| value.to_s.downcase.start_with?(subword) }
        end
      else
        item.values.count { |value| value.to_s.downcase.start_with?(pos_word) }
      end
    end

    relevance_scores.sum
  end
end
