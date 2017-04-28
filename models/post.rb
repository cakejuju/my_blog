class Post < ActiveRecord::Base
  has_and_belongs_to_many :tags
  has_many :pts, dependent: :destroy

  def written_time
    second_time_to_text(Time.now - self.created_at)
  end

end