FactoryBot.define do
  factory :character do
    transient do
      project { create(:project) }
    end

    post { create(:post, project: project) }
  end
end
