FactoryBot.define do
  factory :post_relation do
    transient {
      project { create(:project) }
    }
    from { create(:post, project: project) }
    to { create(:post, project: project) }
    description { "MyString" }
    detail { "MyText" }
  end
end
