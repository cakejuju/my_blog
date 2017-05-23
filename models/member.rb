class Member < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  validates_length_of :nickname, within: 1..60
  # validates :username, uniqueness: true
  validates :email, uniqueness: true
  validates_length_of :email, within: 1..80
end