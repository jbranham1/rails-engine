FactoryBot.define do
  factory :transaction do
    credit_card_number { "1234123412341234" }
    credit_card_expiration_date { "04/23" }
    result { "success" }

    invoice
  end
end
