class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: [:user, :user_manager, :admin]
  after_initialize :set_default_role, if: :new_record?

  has_many :jogging_times, dependent: :destroy

  validates :username, presence: true, length: { maximum: 255 }, uniqueness: true

  def set_default_role
    self.role ||= :user
  end

  def my_times
    JoggingTime.where("user_id = ?", id)
  end

end
