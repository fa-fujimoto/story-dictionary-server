params_length = User::PARAMS_LENGTH

FactoryBot.define do
  factory :user do
    sequence(:name) {|n| "username#{n}"}
    nickname {'aaaaaaa'}
    sequence(:email) {|n| "test#{n}@test.com"}
    password {'Password@1111'}
    password_confirmation {'Password@1111'}

    factory :user_max do
      name { 'a' * params_length.name.max }
      nickname { 'a' * params_length.nickname.max }
      password { 'a' * (params_length.password.max - 3) + '@1A' }
      password_confirmation { 'a' * (params_length.password.max - 3) + '@1A' }
    end

    factory :user_min do
      name { 'a' * params_length.name.min }
      nickname { 'a' * params_length.nickname.min }
      password { 'a' * (params_length.password.min - 3) + '@1A' }
      password_confirmation { 'a' * (params_length.password.min - 3) + '@1A' }
    end
  end
end
