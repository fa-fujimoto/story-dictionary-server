FactoryBot.define do
  factory :project_follower do
    user { create(:user) }
    project { create(:project) }
    approval { :approved }
    permission { :edit }
  end
end
