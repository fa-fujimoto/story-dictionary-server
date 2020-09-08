params_length = Project::PARAMS_LENGTH

FactoryBot.define do
  factory :project do
    sequence(:term_id) { |n| "projectName#{n}" }
    sequence(:name) { |n| "プロジェクトネーム#{n}" }
    sequence(:kana) { |n| "ぷろじぇくとねーむ#{n}" }
    description { 'text' }
    is_published { :published }
    association :author, factory: :user

    factory :project_max do
      term_id { 'a' * params_length.term_id.max }
      name { 'a' * params_length.name.max }
      kana { 'a' * params_length.kana.max }
      description { 'a' * params_length.description.max }
    end

    factory :project_min do
      term_id { 'a' * params_length.term_id.min }
      name { 'a' * params_length.name.min }
      kana { 'a' * params_length.kana.min }
      description { 'a' * params_length.description.min }
    end
  end
end
