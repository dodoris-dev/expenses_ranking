# spec/factories/deputies.rb
FactoryBot.define do
  factory :deputy do
    name { "John Doe" }
    party { "Some Party" }
    state { "Some State" }
    sequence(:cpf) { |n| "1234567890#{n}" } # Ensure unique CPF values
  end
end
