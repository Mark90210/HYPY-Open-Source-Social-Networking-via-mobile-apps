class GalleryPhotoCollection

  attr_accessor :photos

  def initialize(gallery_id, since_id = nil)
    photos = Photo.joins('left join photo_flags on photo_flags.photo_id = photos.id')
    photos = photos.where({ photos: { gallery_id: gallery_id , moderated: true }})#, photo_flags: { id: nil }})
    photos = photos.where('photos.id > ?', since_id.to_i) unless since_id == nil
    @photos = photos.order({ id: :desc })
  end

  def as_json(options = {})
    json = []

    load_user_info = options.has_key?(:load_user_info)
    photos.each do |photo|
      json.push photo.as_json({ load_user_info: load_user_info })
    end

    json
  end

end