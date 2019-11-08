class Gallery < ActiveRecord::Base
  include S3_Uploader
  include API_Resource
  require 'date'
  has_many :photos, dependent: :destroy

  @@keys = [
    :description,
    :name,
    :user_id,
    :owner_type,
    :fb_user_id,
    :fb_password,
    :ig_user_id,
    :ig_password,
    :tw_user_id,
    :tw_password,
    :yt_user_id,
    :yt_password,
    :bypass_moderation
  ]

  attr_accessor :photos, :count_photos, :count_active_users, :status_color, :fb_user_id,
    :fb_password, :ig_user_id, :ig_password, :tw_user_id, :tw_password, :yt_user_id,
    :yt_password, :bypass_moderation 


  def self.create params
    gallery = super() do |gallery|
      @@keys.each do |key|
        gallery[key] = params[key] if params.has_key?(key.to_s) || params.has_key?(key)
      end
    end

    gallery.hero_image = gallery.upload_file params[:hero_image] unless params[:hero_image].nil?

    gallery.save
    gallery
  end

  def update! params
    @@keys.each do |key|
      self[key] = params[key] if params.has_key?(key.to_s)
    end
    set_password params[:password] if params.has_key?('password')
    self.hero_image = Gallery.find(params[:id]).upload_file params["hero_image"]  unless params["hero_image"].nil?
    save
    self
  end
  
  def as_json options
    {
      id: id,
      user_id: user_id,
      owner_type: owner_type,
      name: name,
      description: description,
      location: location,
      hero_image: hero_image,
      count_active_users: count_active_users,
      count_photos: count_photos,
      photos: photos,
      status_color: status_color,
      fb_user_id: fb_user_id,
      fb_password: fb_password,
      tw_user_id: tw_user_id,
      tw_password: tw_password,
      ig_user_id: ig_user_id,
      ig_password: ig_password,
      yt_user_id: yt_user_id,
      yt_password: yt_password,
      bypass_moderation: bypass_moderation,
      created_at: created_at.to_date,
      path: path("/galleries/#{id}")
    }
  end

  def load_photos include_all_content = false, include_user_content = nil
    if include_all_content
      photos = Photo.where({ gallery_id: id })
    elsif include_user_content == nil
      photos = Photo.joins('left join photo_flags on photo_flags.photo_id = photos.id').where({ photos: { gallery_id: id, moderated: true }, photo_flags: { id: nil } }) 
    else
      photos = Photo.joins('left join photo_flags on photo_flags.photo_id = photos.id').where({ photos: { gallery_id: id }, photo_flags: { id: nil }}).where('photos.moderated = ? or photos.user_id = ?', true, include_user_content) 
    end
    @photos = photos.order({ id: :desc })
  end

  def load_count_photos include_all_content = false
    load_photos(include_all_content) unless @photos
    @count_photos = @photos.length
  end
  
  def load_count_active_users
    users = [0, 1, 2]
    @count_active_users = users.length
  end

  def set_event_status_color
    bypass_moderation_status = self.bypass_moderation 
    if bypass_moderation_status
      @status_color = 'blue'
    else
      count_moderated_contents = Photo.where(gallery_id: self.id, moderated: true).count
      count_unmoderated_contents = Photo.where(gallery_id: self.id, moderated: false).count
      if ( count_moderated_contents == 0 ) && ( count_unmoderated_contents == 0 )
        @status_color = 'white'
      elsif ( count_moderated_contents == 0 )
        @status_color = 'red'
      elsif ( count_unmoderated_contents == 0 )
        @status_color = 'green'
      else
        @status_color = 'yellow'
      end
    end 
  end

  def load_app_credentials
    @fb_user_id = self[:fb_user_id]
    @fb_password = self[:fb_password]
    @tw_user_id = self[:tw_user_id]
    @tw_password = self[:tw_password]
    @ig_user_id = self[:ig_user_id]
    @ig_password = self[:ig_password]
    @yt_user_id = self[:yt_user_id]
    @yt_password = self[:yt_password]
    @bypass_moderation = self[:bypass_moderation]
  end

end
