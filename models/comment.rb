class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :member

  validates :content, presence: true

  def head_img_url
    self.member.head_img_url
  end

  def nickname
    self.member.nickname
  end

  def marked_content
    self.content.to_s.marked
  end

  def written_time
    second_time_to_text(Time.now - self.created_at)
  end
end