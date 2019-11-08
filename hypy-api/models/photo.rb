class Photo < ActiveRecord::Base
  include S3_Uploader
  include Image_Resizer

  has_many :photo_flags, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  @@keys = [
    :user_id,
    :gallery_id,
    :description,
    :location,
    :dimension
  ]
  
  attr_accessor :user_name, :user_profile_image, :comments, :count_likes, :user_has_liked, :count_comments, :message

  def self.create params
    photo = super() do |photo|
      @@keys.each do |key|
        photo[key] = params[key] if params.has_key?(key.to_s) || params.has_key?(key)
      end
    end
    photo.moderated = params[:moderated] if params.has_key? :moderated
    gallery = Gallery.find params[:gallery_id]
    if gallery.bypass_moderation?
      photo.moderated = true
    end
    photo.file_url = photo.upload_file(params[:photo])
    photo.dimension = Dimensions.dimensions(params[:photo][:tempfile]) if ['.jpg','.jpeg','.tif','.gif','.png','.img'].include?(File.extname(params[:photo][:tempfile].path))
    photo.save
    photo
  end

  def check_photo_flag
    # method to check photo flag
    @flagged = PhotoFlag.where({ photo_id: self.id }).length
    if @flagged == 0
      return true
    else
      return false
    end
  end

  def flagged
    return false unless moderated

    @flagged = PhotoFlag.where({ photo_id: id }).length > 0 unless @flagged
    return @flagged
  end

  def as_json(options = {})
    load_user_info if options[:load_user_info]
    json = {
      id: id,
      user_id: user_id,
      user_name: user_name,
      user_profile_image: user_profile_image,
      file_url: file_url,
      description: description,
      comments: comments,
      count_likes: count_likes,
      count_comments: count_comments,
      created_at: created_at.strftime("%d-%m-%Y %l:%M:%S %p %Z"),
      flagged: flagged,
      moderated: moderated,
      user_has_liked: user_has_liked,
      message: message,
      location: location,
      dimension: dimension,
      thumb_url: thumb_photo
    }

    json[:object_type] = self.class.name if options[:include_object_type]
    json
  end
  
  def load_user_info
    @user = User.find user_id
    @user_name = @user.name
    @user_profile_image = @user.profile_image
  end

  def load_photo_message
    gallery = Gallery.find self.gallery_id
    @message = gallery.bypass_moderation? ? "Success!" : "Success! This content will appear under gallery, once admin approves!"
    @message 
  end

  def load_comments
    if @user == nil then
      @user = User.find user_id
    end
    @comments = Comment.where({ photo_id: id }) if @comments.nil?
    @comments
  end

  def load_count_likes
    @count_likes = Like.where({ photo_id: id }).count if @count_likes.nil?
    @count_likes
  end

  def load_count_comments
    @count_comments = Comment.where({ photo_id: self.id }).count if @count_comments.nil?
    @count_comments
  end

  def load_thumb photo_thumb
    thumb_filename = Digest::SHA2.hexdigest [Time.now, rand].join
    thumb_filename = thumb_filename + ".jpg"
    if ['.mp4','.mov','.avi','.3gp','.flv','.wmv'].include?(File.extname(photo_thumb[:tempfile].path))
      movie = FFMPEG::Movie.new(photo_thumb[:tempfile].path)
      video = movie.screenshot(thumb_filename, seek_time: 2, resolution: '320x240')
    else
      image = MiniMagick::Image.new(photo_thumb[:tempfile].path)
      image.resize "320x240"
      image.format "jpg"
      image.write thumb_filename
    end
    self.thumb_photo = S3_Uploader.upload_thumb(File.open(thumb_filename), thumb_filename)
    self.save
    File.delete(thumb_filename)
  end

end