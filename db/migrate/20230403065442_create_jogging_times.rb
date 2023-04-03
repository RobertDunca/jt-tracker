class CreateJoggingTimes < ActiveRecord::Migration[7.0]
  def change
    create_table :jogging_times do |t|
      t.date :date
      t.float :distance
      t.time :time
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :jogging_times, %i[user_id created_at]
    add_index :jogging_times, :date
  end
end
