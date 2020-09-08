FactoryBot.define do
  factory :attribute_option do
    sequence(:name) {|n| "name#{n}" }
    sequence(:value) {|n| n }
    item { create(:attribute_item, :select_item) }
  end
end
