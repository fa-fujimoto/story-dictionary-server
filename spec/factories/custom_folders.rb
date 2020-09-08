FactoryBot.define do
  length = CustomFolder::PARAMS_LENGTH

  factory :custom_folder do
    sequence(:term_id) {|n| "term_id#{n}"}
    sequence(:name) {|n| "username#{n}"}
    is_visible { :visible }
    association :project

    trait :max do
      term_id { 'a' * length.term_id.max }
      name { 'a' * length.name.max }
    end

    trait :min do
      term_id { 'a' * length.term_id.min }
      name { 'a' * length.name.min }
    end
  end
end
