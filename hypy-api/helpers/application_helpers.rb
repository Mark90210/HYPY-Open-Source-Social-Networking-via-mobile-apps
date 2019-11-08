module ApplicationHelpers

  def current_user
    if params[:token]
      User.find_by_token(params[:token])
    elsif session[:user]
      User.find(session[:user])
    else
      NoUser.new
    end
  end

  def deny_access
    session.delete :user
    redirect to '/login'
  end



  #### 200 series
  def ok object
    status 200
    object.to_json
  end
  alias json ok

  def created object
    status 201
    object.to_json
  end

  def updated object
    status 200
    object.to_json
  end

  def no_content
    status 204
  end

  #### 400 series
  def unauthorized
    status 401
    {
      error: 'Unknown User! Log In again'
    }.to_json
  end

  def blocked
    status 401
    {
      error: 'Admin has blocked your account!'
    }.to_json
  end

  def forbidden
      status 403
      {
        error: 'Unauthorized Action'
      }.to_json
  end

  def not_found
    status 404
    {
      error: 'Not Found'
    }.to_json
  end

  def success
    status 200
    {
      message: 'Success'
    }.to_json
  end

  #### 500 series
  def error_message message
    status 500
    {
      error: message
    }.to_json
  end

  def error
    error_message 'Internal Server Error'
  end

  def set_user_profile_image(user_id)
    user = User.find(user_id)
    user.profile_image.present? ?  user.profile_image : "./../user_profile_image.png"
  end

  def set_user_name(user_id)
    user = User.find(user_id)
    user_name = "#{user.first_name} #{user.last_name}"
    user_name
  end

  def set_user_image(user_id)
    user = User.find(user_id)
    user.profile_image.present? ?  user.profile_image : "./../../user_profile.png"
  end

  def count_flagged(user_id)
    count = 0
    user = User.find(user_id)
    if user.photos.exists?
      user.photos.each do |photo|
        if PhotoFlag.find_by(photo_id: photo.id).present?
          count = count + 1
        end
      end
    end
    count
  end
end