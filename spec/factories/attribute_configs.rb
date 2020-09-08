FactoryBot.define do
  factory :attribute_config do
    transient do
      sequence(:custom_folder_term_id) { |n| "termid#{n}" }
      sequence(:custom_folder_name) { |n| "name#{n}" }
    end

    association :project, factory: :project
    association :item, factory: :attribute_item
    is_visible { :visible }

    trait :with_word do
      item { create(:attribute_item, :word_group) }
    end

    trait :with_character do
      item { create(:attribute_item, :character_group) }
    end

    trait :with_custom do
      item { create(:attribute_item, :custom_group, custom_folder_term_id: custom_folder_term_id, custom_folder_name: custom_folder_name) }
    end
  end
end
