class Photograph < ActiveRecord::Base
  validates :img_url, uniqueness: true

  def exif_v
    return nil if exif == 'null'
    JSON.parse(exif)
  end
end