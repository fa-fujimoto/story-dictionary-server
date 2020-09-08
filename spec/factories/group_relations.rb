FactoryBot.define do
  factory :group_relation do
    transient {
      project { create(:project) }
    }
    from { create(:group, project: project) }
    to { create(:group, project: project) }
    description { "MyString" }
    detail { "MyText" }
  end
end
