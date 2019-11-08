#
post '/users/me' do
  begin  
    if User.find_by(phone: params[:phone]).present?
      user = User.find_by(phone: params[:phone])
      return blocked unless user.check_active
    else
      user = User.create(params)
    end
    user.send_verification_code
    status 200
    return json ({
      success: !!user
    })
  rescue
    status 500
  end  
end

post '/users/me/confirmation' do
  user = User.find_by(phone: params[:phone])
  return blocked unless user.check_active
  if user.present?
    success = params[:verification_code] == user.verification_code
    if success
      user.confirm!
      status 200
      return json ({
        success: success,
        token: user.token
      })
    else
      return not_found
    end
  else
    return not_found
  end
end

get '/users/me/events' do
  return forbidden unless current_user

  events = Gallery.all.shuffle.slice 0..1

  return json events
end

put '/users/me' do
  return forbidden unless current_user
  return blocked unless current_user.check_active
  return unauthorized if current_user[:type].present? && current_user[:type].eql?('NoUser')
  begin
    current_user.update! params
    status 200
    return json current_user
  rescue
    status 500
  end  
end

get '/version' do
  version = ENV['HEROKU_RELEASE_VERSION'].present? ? ENV['HEROKU_RELEASE_VERSION'] : nil
  {
    version: version
  }.to_json
end

get '/users/me' do

  return forbidden unless current_user
  return blocked unless current_user.check_active

  return unauthorized if current_user[:type].present? && current_user[:type].eql?('NoUser')

  user = current_user

  return unauthorized unless ACL.user_can_view_user current_user, user
  status 200
  return json user
end
