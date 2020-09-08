FactoryBot.define do
  factory :comment do
    author { create(:user) }
    post { create(:post) }
    body { "MyText" }
    status { :open }

    trait :has_children do
      after(:create) do |instance|
        create(:comment, post: instance.post, reply_to: instance)
      end
    end

  end
end
