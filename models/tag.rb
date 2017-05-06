# 文章标签 
class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts
  has_many :pts, dependent: :destroy
  validates :name, uniqueness: true
end