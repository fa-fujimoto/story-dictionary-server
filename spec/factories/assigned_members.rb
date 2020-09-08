FactoryBot.define do
  factory :assigned_member do
    transient do
      project { build(:project) }
    end

    group { build(:group, project: project) }
    member { build(:character, project: project) }
    description { "MyString" }
  end
end
