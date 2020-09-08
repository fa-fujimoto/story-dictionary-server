FactoryBot.define do
  factory :word do
    transient do
      project { create(:project) }
    end

    post { create(:post, project: project) }
  end
end
