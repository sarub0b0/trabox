FactoryBot.define do
  factory :relayer_test do
    sequence(:event_data) { |n| n.to_s }
    published_at { nil }
    message_id { nil }
  end
end
