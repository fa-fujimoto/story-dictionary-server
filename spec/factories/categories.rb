params_length = Category::PARAMS_LENGTH

FactoryBot.define do
  factory :category do
    sequence(:term_id) { |n| "term_id#{n}" }
    sequence(:name) { |n| "word_name#{n}" }
    association :project, factory: :project
    synopsis { 'synopsis text' }
    body { 'body text' }
    kind { 'word' }

    trait :word do
      kind { 'word' }
    end

    trait :character do
      kind { 'character' }
    end

    factory :category_max do
      term_id { 'a' * params_length.term_id.max }
      name { 'a' * params_length.name.max }
      synopsis { 'あ' * params_length.synopsis.max }
      body { 'あ' * params_length.body.max }
    end

    factory :category_min do
      term_id { 'a' * params_length.term_id.min }
      name { 'a' * params_length.name.min }
      synopsis { nil }
      body { nil }
    end
  end
end
