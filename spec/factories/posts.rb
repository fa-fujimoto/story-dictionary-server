length = Post::PARAMS_LENGTH

FactoryBot.define do
  factory :post do
    sequence(:term_id) { |n| "term_id#{n}" }
    sequence(:name) { |n| "word_name#{n}" }
    kana { 'よみがな' }
    synopsis { "MyString" }
    status { :published }
    category { nil }
    association :project, strategy: :create
    association :author, factory: :user
    last_editor { author }
    with_word

    trait :published do
      status { :published }
    end

    trait :protect do
      status { :protect }
      disclosure_range { :followers_only }
    end

    trait :draft do
      status { :draft }
    end

    trait :requesting do
      status { :requesting }
    end

    trait :deleted do
      status { :deleted }
    end

    trait :with_word do
      after(:build) do |instance|
        build(:word, post: instance)
      end
    end

    trait :with_character do
      after(:build) do |instance|
        instance.word = nil
        build(:character, post: instance)
      end
    end

    trait :with_group do
      after(:build) do |instance|
        instance.word = nil
        build(:group, post: instance)
      end
    end

    trait :with_custom do
      after(:build) do |instance|
        instance.word = nil
        instance.custom_folder = create(:custom_folder, project: instance.project) unless instance.custom_folder

        build(:custom_post, post: instance)
      end
    end

    trait :with_nil do
      after(:build) do |instance|
        instance.character = nil
        instance.word = nil
      end
    end

    trait :with_multi do
      after(:build) do |instance|
        build('word', post: instance)
        build('character', post: instance)
      end
    end

    trait :max do
      term_id { 'a' * length.term_id.max }
      name { 'a' * length.name.max }
      kana { 'あ' * length.kana.max }
      synopsis { 'あ' * length.synopsis.max }
    end

    trait :min do
      term_id { 'a' * length.term_id.min }
      name { 'a' * length.name.min }
      kana { 'あ' * length.kana.min }
      synopsis { nil }
      last_editor { nil }
      category { nil }
    end
  end
end
