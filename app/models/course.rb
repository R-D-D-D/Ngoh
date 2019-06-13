class Course < ApplicationRecord
  belongs_to :tutor
  has_many :lessons, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :students, through: :subscriptions, source: :student

  has_one_attached :image

  default_scope -> { order(created_at: :desc) }

  validates :title,
    presence: true,
    length: { maximum: 50 }

  validates :content,
    presence: true
end
