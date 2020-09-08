FactoryBot.define do
  factory :attribute_value do
    transient do
      required { false }
      project { create(:project) }
    end

    post { create(:post, project: project) }
    is_visible { true }

    after(:build) do |instance, evaluator|
      if instance.item && instance.post.project && !instance.post.project.attribute_configs.exists?(attribute_item_id: instance.item.id)
        create(:attribute_config, project: instance.post.project, item: instance.item)
      end
    end

    trait :with_string do
      string { 'word' }
      item { create(:attribute_item, :string_item, required: required) }
    end

    trait :with_integer do
      integer { 1 }
      item { create(:attribute_item, :integer_item, required: required) }
    end

    trait :with_text do
      text { 'a' * 1000 }
      item { create(:attribute_item, :text_item, required: required) }
    end

    trait :with_markdown do
      markdown { 'a' * 1000 }
      item { create(:attribute_item, :markdown_item, required: required) }
    end

    trait :with_boolean do
      boolean { true }
      item { create(:attribute_item, :boolean_item, :with_options, required: required) }
    end

    trait :with_select do
      selected { 0 }
      item { create(:attribute_item, :select_item, :with_options, required: required) }
    end
  end
end
