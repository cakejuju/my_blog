class Photograph < ActiveRecord::Base
  validates :img_url, uniqueness: true

  def exif_v
    return nil if exif == 'null'
    JSON.parse(exif)
  end

  def shot_at
    second_time_to_text(Time.now - self.created_at)
  end
end