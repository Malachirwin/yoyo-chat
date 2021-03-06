class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true, length: {maximum: 30, minimum: 2}
  validates :content, presence: true, length: {maximum: 250, minimum: 2}
end
