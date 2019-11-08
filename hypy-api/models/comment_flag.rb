class CommentFlag < ActiveRecord::Base
  include API_Resource
  extend FindOrCreate

  @@keys = [
    :user_id,
    :comment_id
  ]

  def self.create params
    flag = super() do |flag|
      @@keys.each do |key|
        flag[key] = params[key] if params.has_key?(key.to_s) || params.has_key?(key)
      end
    end

    flag.save
    flag
  end

  def as_json(options = {})
    json = {
      id: id,
      user_id: user_id,
      comment_id: comment_id,
      created_at: created_at
    }

    json
  end

end