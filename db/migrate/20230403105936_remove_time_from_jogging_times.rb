class RemoveTimeFromJoggingTimes < ActiveRecord::Migration[7.0]
  def change
    remove_column :jogging_times, :time, :time
  end
end
