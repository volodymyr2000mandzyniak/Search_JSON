# spec/factories/data.rb

FactoryBot.define do
  factory :data, class: Hash do
    sequence(:Name) { |n| "Language #{n}" }
    Type { "Compiled, Curly-bracket, Imperative, Procedural" }
    Designed_by { "Designer #{rand(1..100)}" }
  end
end
