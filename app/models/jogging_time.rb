class JoggingTime < ApplicationRecord
  attr_accessor :hours, :minutes, :seconds

  belongs_to :user
  default_scope -> { order(date: :desc) }

  validates :date, :distance, :duration, :user_id, presence: true
  validates :duration, numericality: { greater_than_or_equal_to: 1 }
  validates :distance, numericality: { greater_than_or_equal_to: 0.1 }
  validates :hours, :minutes, :seconds, numericality: {
                                                        only_integer: true,
                                                        greater_than_or_equal_to: 0,
                                                        less_than_or_equal_to: 59
                                                      }

  before_validation :set_duration

  def average_speed
    (distance / duration * 1.hour).round(2)
  end

  def formatted_time
    "%02d:%02d:%02d" % [duration / 3600, duration / 60 % 60, duration % 60]
  end

  private

    def set_duration
      self.duration = hours.to_i * 3600 + minutes.to_i * 60 + seconds.to_i
    end

end
