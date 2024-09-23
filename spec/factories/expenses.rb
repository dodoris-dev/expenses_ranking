FactoryBot.define do
  factory :expense do
    amount { 100.0 }
    description { "Some expense" }
    date { Date.today }
    association :deputy
  end
end
