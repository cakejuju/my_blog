class PostsTags < ActiveRecord::Base
  # TODO 在company_discouts被删除是 对应的关系表也该删除
  belongs_to :post
  belongs_to :tag
  validates :post, presence: true
  validates :tag, presence: true
end

