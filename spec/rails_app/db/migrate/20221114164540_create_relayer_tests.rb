class CreateRelayerTests < ActiveRecord::Migration[6.0]
  def change
    create_table :relayer_tests do |t|
      t.binary :event_data
      t.string :message_id
      t.datetime :published_at

      t.timestamps
    end
  end
end
