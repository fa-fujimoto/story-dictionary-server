FactoryBot.define do
  factory :character_relation do
    transient {
      project { create(:project) }
    }

    from { create(:character, project: project) }
    to { create(:character, project: project) }
    description { "MyString" }
    detail { "MyText" }
    name { "MyString" }
  end
end
