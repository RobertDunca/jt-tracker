class JoggingTime < ApplicationRecord
  attr_accessor :hours, :minutes, :seconds
  belongs_to :user
  validates :date, :distance, :duration, :user_id, presence: true
  before_validation :set_duration

  def average_speed
    speed = distance / duration
    (speed * 1.hour).round(2)
  end

  private

    def set_duration
      self.duration = hours.to_i * 3600 + minutes.to_i * 60 + seconds.to_i
    end

end
