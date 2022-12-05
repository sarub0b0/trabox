class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.binary :event_data
      t.string :message_id
      t.datetime :published_at

      t.timestamps
    end
  end
end
