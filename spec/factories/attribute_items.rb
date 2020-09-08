FactoryBot.define do
  factory :attribute_item do
    transient do
      sequence(:custom_folder_term_id) { |n| "custom_folder#{n}" }
      sequence(:custom_folder_name) { |n| "custom_folder#{n}" }
      length { 2 }
      project { create(:project) }
    end

    sequence(:name) { |n| "name#{n}" }
    post_type { :word }
    kind { :string }
    required

    trait :required do
      required { true }
    end

    trait :no_required do
      required { false }
    end

    trait :string_item do
      kind { :string_type }
    end

    trait :integer_item do
      kind { :integer_type }
    end

    trait :text_item do
      kind { :text_type }
    end

    trait :markdown_item do
      kind { :markdown_type }
    end

    trait :boolean_item do
      kind { :boolean_type }
    end

    trait :select_item do
      kind { :select_type }
    end

    trait :with_options do
      after(:create) do |instance|
        create(:attribute_option, value: 0, item: instance)
        create(:attribute_option, value: 1, item: instance)
      end
    end

    trait :word_group do
      post_type { :word }
    end

    trait :character_group do
      post_type { :character }
    end

    trait :custom_group do
      custom_folder { create(:custom_folder, term_id: custom_folder_term_id, name: custom_folder_name) }
      post_type { :custom }
    end
  end
end
