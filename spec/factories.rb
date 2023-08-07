FactoryBot.define do
  factory :customer do
    first_name {Faker::Name.first_name}
    last_name {Faker::Dessert.variety}
  end

  factory :invoice do
    status {[0,1,2].sample}
    customer
    merchant
  end

  factory :merchant do
    name {Faker::Space.galaxy}
    # invoices
    # items
    # after(:create) do |merchant|
    #   create_list(:item, 5, merchant: merchant)
    #   create_list(:invoice, 5, merchant: merchant)
    # end
  end

  factory :item do
    name {Faker::Coffee.variety}
    description {Faker::Hipster.sentence}
    unit_price {Faker::Number.decimal(l_digits: 2)}
    merchant
  end

  factory :transaction do
    result {[0,1].sample}
    credit_card_number {Faker::Finance.credit_card}
    invoice
  end

  factory :invoice_item do
    status {[0,1,2].sample}
    merchant
    invoice
  end

  factory :bulk_discount do
    name {Faker::Lorem.word}
    percentage_discount {rand(5..30)}
    quantity_threshold {rand(5..20)}
    merchant
  end

  factory :bulk_discount_item do
    bulk_discount
    item
  end

end
