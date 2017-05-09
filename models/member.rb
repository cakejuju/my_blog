class Member < ActiveRecord::Base
  has_many :comments, dependent: :destroy

  validates :username, uniqueness: true
end