class Post < ApplicationRecord
  belongs_to :lesson
  has_many :messages, dependent: :destroy
end
