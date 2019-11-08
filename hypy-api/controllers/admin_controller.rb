get '/admin' do
  content_type 'text/html'

  redirect to '/dashboard'
end

get '/dashboard' do
  content_type 'text/html'

  redirect to '/login' unless current_user.access_level >= Admin.access_level

  haml :dashboard, locals: { user: current_user } 
end

get '/moderation/:id' do
  content_type 'text/html'

  redirect to '/login' unless current_user.access_level >= Admin.access_level

  gallery = Gallery.find params[:id]
  redirect to '/dashboard' unless gallery.user_id = current_user.id

  photos = Photo.where gallery_id: gallery.id, moderated: false
  haml :moderation, layout: :layout, locals: { user: current_user, gallery: gallery, photos: photos }
end
get '/moderation/:gallery_id/approve/:photo_id' do
  redirect to '/login' unless current_user.access_level >= Admin.access_level

  gallery = Gallery.find params[:gallery_id]
  photo = Photo.find params[:photo_id]

  redirect to '/dashboard' unless gallery.user_id = current_user.id and photo.gallery_id == gallery.id

  photo.moderated = true
  photo.save

  redirect to "/moderation/#{gallery.id}"
end
get '/moderation/:gallery_id/reject/:photo_id' do
  redirect to '/login' unless current_user.access_level >= Admin.access_level

  gallery = Gallery.find params[:gallery_id]
  photo = Photo.find params[:photo_id]

  redirect to '/dashboard' unless gallery.user_id = current_user.id and photo.gallery_id == gallery.id

  photo.moderated = true  
  photo.save

  flag = PhotoFlag.create photo_id: photo.id, user_id: current_user.id

  redirect to "/moderation/#{gallery.id}"
end


get '/admin/photos' do
  deny_access unless current_user.access_level >= Admin.access_level

  photos = Photo.all.order id: :desc
  photos.to_json load_user_info: true
end

get '/admin/photos/:id' do
  deny_access unless current_user.access_level >= Admin.access_level
  
  photo = Photo.find params[:id]
  photo.load_comments 
  photo.comments.each do |comment| 
    comment.load_user_info
  end
  photo.to_json load_user_info: true
end

get '/admin/galleries' do
  deny_access unless current_user.access_level >= Admin.access_level

  galleries = Gallery.all.order created_at: :desc
  galleries.each do |gallery|
    if !params.has_key?('remove_photos')
      gallery.load_photos true
      gallery.load_count_photos
      gallery.load_count_active_users
      gallery.photos.map do |photo|
        photo.load_user_info
      end
    end
    gallery.set_event_status_color
    gallery.load_app_credentials  
  end

  return json galleries
end

get '/admin/galleries/:id' do
  deny_access unless current_user.access_level >= Admin.access_level

  gallery = Gallery.find params[:id]
  gallery.load_app_credentials
  gallery.set_event_status_color  
  return json gallery
end

get '/admin/galleries/:id/feed' do
  deny_access unless current_user.access_level >= Admin.access_level

  gallery = Gallery.find params[:id]
  photos = Photo.where gallery_id: gallery.id

  events = []
  photo_ids = []

  photos.each do |photo|
    photo_ids.push photo.id
    photo.load_count_likes
    photo.load_count_comments
    events.push photo
  end
  
  if !params.has_key?('remove_comments')
    comments = Comment.where photo_id: photo_ids

    comments.each do |comment|
      events.push comment
    end
  end

  events.sort_by! do |event|
    event.created_at
  end
  events.reverse!

  return json events.as_json load_user_info: true, include_object_type: true
end

delete '/admin/galleries/:id' do
  deny_access unless current_user.access_level >= Admin.access_level

  begin
    gallery = Gallery.find params[:id]
  rescue
    status 404
  else
    begin
      gallery.destroy
    rescue
      status 403
    else
      status 204
    end
  end
end
get '/admin/galleries/:id/delete' do
  deny_access unless current_user.access_level >= Admin.access_level

  begin
    gallery = Gallery.find params[:id]
    gallery.destroy
  ensure
    redirect to '/admin/galleries'
  end

end

delete '/admin/comments/:comment_id' do
  deny_access unless current_user.access_level >= Admin.access_level

  begin
    comment = Comment.find params[:comment_id]
  rescue
    status 404
  else
    begin
      comment.destroy
    rescue
      status 403
    else
      status 204
    end
  end
    
end

delete '/admin/photos/:photo_id' do
  deny_access unless current_user.access_level >= Admin.access_level
  begin
    photo = Photo.find params[:photo_id]
  rescue
    return not_found
  else
    begin
      comments = Comment.where(photo_id: params[:photo_id])
      if comments.exists?
        comments.each do |comment| 
          begin
            comment.destroy
          rescue
            return forbidden
          end 
        end
      end
      flags = PhotoFlag.where photo_id: params[:photo_id]
      if flags.exists?
        flags.each do |flag|
          flag.delete
        end  
      end
      likes = Like.where photo_id: params[:photo_id]
      if likes.exists?
        likes.each do |like|
          like.delete
        end  
      end 
      photo.destroy
    rescue
      return forbidden
    else
      return success
    end
  end
end

get '/admin/users' do
  deny_access unless current_user.access_level >= Admin.access_level

  users = User.all.order id: :asc
  users.to_json include_id: true
end

put '/admin/users/:id' do
  deny_access unless current_user.access_level >= Admin::access_level

  user = User.find params[:id]
  user.update! params
  user.reload

  return ok user.as_json include_id: true

end

delete '/admin/photos/:id/flag' do
  deny_access unless current_user.access_level >= Admin::access_level

  flags = PhotoFlag.where photo_id: params[:id]

  begin
    flags.each do |flag|
      flag.delete
    end
  rescue
    return forbidden
  else
    return no_content
  end  
end

delete '/admin/photos/:photo_id/comments/:comment_id/flag' do
  deny_access unless current_user.access_level >= Admin::access_level

  flags = CommentFlag.where comment_id: params[:comment_id]

  begin
    flags.each do |flag|
      flag.delete
    end
  rescue
    status 403
  else
    status 204
  end  
end

# comment edit
get '/admin/comments/:comment_id' do
  deny_access unless current_user.access_level >= Admin.access_level
    @comment = Comment.get(params[:comment_id])
end

# comment update
put '/admin/comments/:comment_id' do
  deny_access unless current_user.access_level >= Admin.access_level
    @comment_object = Comment.find params[:comment_id]
    @comment_object.update! params
    return updated @comment_object 
end

# user edit
get '/admin/user/:user_id' do
  content_type 'text/html'
  # deny_access unless current_user.access_level >= Admin.access_level
    @user = current_user   if current_user.present?
    haml :user, locals: { user: current_user } 
end

# user update
put '/admin/user/:user_id' do
  # deny_access unless current_user.access_level >= Admin.access_level
    @user_object = User.find params[:user_id]
    if params["file"].present?
      image = current_user.upload_file params["file"]
    else
      image = current_user.profile_image
    end
    @user_object.set_password params["user"]["password"] if params["user"]["password"] != ""
    @user_object.update_attributes(first_name: params["user"]["first_name"], last_name: params["user"]["last_name"],
      email: params["user"]["email"], phone: params["user"]["phone"], profile_image: image, password_hash: @user_object.password_hash, salt: @user_object.salt)
    flash[:success] = "Details has been updated"
    redirect to "/admin/user/#{current_user.id}"
end


get '/admin/admin_users' do
  content_type 'text/html'
  deny_access unless current_user.access_level >= Admin.access_level

  admins = User.where(is_admin: true).all.order created_at: :desc
  haml :admin_user, locals: { admin_user: admins } 
end

get '/admin/update_admin/:id' do
  if params[:id].split(',')[1] == 'Admin'
    User.find_by(id: params[:id].split(',')[0]).update(type: 'Admin')
    flash[:success] = "Admin has been activated"
  else
    User.find_by(id: params[:id].split(',')[0]).update(type: nil)
    flash[:error] = "Admin has been deactivated"
  end
  deny_access unless current_user.access_level >= Admin.access_level
  redirect to "/admin/admin_users"
end

post '/admin/admin_create' do
  deny_access unless current_user.access_level >= Admin.access_level
  email = Admin.find_by(email: params["user"]["email"])
  if email.present?
    flash[:error] = "Email has been already taken"
  else
    Admin.create({
    first_name: params["user"]["first_name"],
    last_name: params["user"]["last_name"],
    email: params["user"]["email"],
    password: params["user"]["password"],
    is_admin: true
    })
    flash[:success] = "Admin has been created"
  end
    admins = Admin.all.order created_at: :desc
  redirect to "/admin/admin_users"
end

get '/admin/manage_users' do
  content_type 'text/html'
  deny_access unless current_user.access_level >= Admin.access_level
  users = User.where(type: nil).order created_at: :desc
  haml :manage_users, locals: { users: users }
end

get '/admin/update_user/:id' do
  if params[:id].split(',')[1] == 'Active'
    User.find_by(id: params[:id].split(',')[0]).update(is_active: false)
    flash[:error] = "User has been blocked"
  else
    User.find_by(id: params[:id].split(',')[0]).update(is_active: true)
    flash[:success] = "User has been unblocked"
  end
  deny_access unless current_user.access_level >= Admin.access_level
  redirect to "/admin/manage_users"
end

delete '/admin/delete_user/:id' do
  begin
    user = User.find_by(id: params[:id])
    if user.present?
      user.destroy!
      flash[:success] = "User has been deleted"
    end
  rescue
    flash[:error] = "Something went wrong!"
  end  
  redirect to "/admin/manage_users"
end
