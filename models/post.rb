class Post < ActiveRecord::Base
  has_and_belongs_to_many :tags
  has_many :pts, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  validates :title, uniqueness: true

  def written_time
    second_time_to_text(Time.now - self.created_at)
  end

  def tag_names
    self.tags.as_json(only: [:id, :name])
  end

  def l_content
    if self.content.to_s.size > 300
      content = self.content[0..300] + '.....'
      # TODO
      # if content.include?('<img>')
      # end
    else 
      self.content
    end
  end

end