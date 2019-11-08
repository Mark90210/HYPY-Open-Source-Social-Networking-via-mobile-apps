class Comment < ActiveRecord::Base

  @@keys = [
    :user_id,
    :photo_id,
    :text
  ]

  attr_accessor :flagged, :user_name, :user_profile_image

  def self.create params
    comment = super() do |comment|
      @@keys.each do |key|
        comment[key] = params[key] if params.has_key?(key.to_s) || params.has_key?(key)
      end
    end

    comment.save
    comment
  end
    
  def update! params
    @@keys.each do |key|
      self[key] = params[key] if params.has_key?(key.to_s)
    end
    self.text = params[:text] if params.has_key?('text')
    save
    self
  end
    
  def as_json(options = {})
    load_user_info if options[:load_user_info] || true

    json = {
      id: id,
      user_id: user_id,
      user_name: user_name,
      user_profile_image: user_profile_image,
      photo_id: photo_id,
      text: text,
      flagged: flagged,
      created_at: created_at.strftime("%d-%m-%Y %l:%M:%S %p %Z")
    }

    json[:object_type] = self.class.name if options[:include_object_type]

    json
  end
  
  def load_user_info
    user = User.find user_id
    @user_name = user.name
    @user_profile_image = user.profile_image
  end

  def flagged
    unless @flagged
      flags = CommentFlag.where comment_id: id
      @flagged = flags.length > 0
    end
    @flagged
  end

end

class Description < Comment

  def initialize comment, user, photo
    @comment = comment
    @user = user
    @photo = photo
  end

  def load_user_info
  end

  def as_json(options = {})
    json = {
      id: nil,
      user_id: @user.id,
      user_name: @user.name,
      user_profile_image: @user.profile_image,
      photo_id: @photo.id,
      text: @comment,
      flagged: false,
      created_at: nil
    }

    json[:object_type] = self.class.name if options[:include_object_type]

    json
  end
end