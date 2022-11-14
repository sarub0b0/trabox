FactoryBot.define do
  factory :relayable_test do
    sequence(:event_data) { |n| n.to_s }
    published_at { nil }
    message_id { nil }
  end
end
