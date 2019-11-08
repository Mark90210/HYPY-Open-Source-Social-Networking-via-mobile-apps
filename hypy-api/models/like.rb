class Like < ActiveRecord::Base
  extend FindOrCreate
  attr_accessor :user_name, :user_profile_image

  @@keys = [
    :user_id,
    :photo_id
  ]

  def self.create params
    like = super() do |like|
      @@keys.each do |key|
        like[key] = params[key] if params.has_key?(key.to_s) || params.has_key?(key)
      end
    end

    like.save
    like
  end

  def self.exists? where
    objects = self.where where
    objects.length >= 1
  end
    
  def as_json(options = {})
    json = {
      id: id,
      user_id: user_id,
      photo_id: photo_id,
      created_at: created_at.strftime("%d-%m-%Y %l:%M:%S %p %Z"),
      user_name: user_name,
      user_profile_image: user_profile_image
    }

    json
  end

  def load_user_info
    @user = User.find user_id
    @user_name = @user.name
    @user_profile_image = @user.profile_image
  end

end