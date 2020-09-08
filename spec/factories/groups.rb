FactoryBot.define do
  factory :group do
    transient do
      project { create(:project) }
    end

    post { create(:post, project: project) }
    is_department { false }
  end
end
