class Post < ActiveRecord::Base
  has_and_belongs_to_many :tags
  has_many :pts, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  validates :title, uniqueness: true
  validates :content, presence: true

  def written_time
    second_time_to_text(Time.now - self.created_at)
  end

  def tag_names
    self.tags.as_json(only: [:id, :name])
  end

  def l_content
    self.content
  end

  def created_strftime
    self.created_at.strftime("%Y年%-m月%-d日")
  end
end