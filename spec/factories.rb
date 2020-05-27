FactoryBot.define do
  factory :user do
    name {"John"}
    address {"123 town"}
    city {"denver"}
    state {"CO"}
    zip {"80127"}
    email {"test.com"}
    password {"1234"}
  end
end
