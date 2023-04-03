class AddDurationToJoggingTimes < ActiveRecord::Migration[7.0]
  def change
    add_column :jogging_times, :duration, :integer
  end
end
