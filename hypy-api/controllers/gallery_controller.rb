get '/galleries' do
  galleries = Gallery.where({ user_id: current_user.id }).order({ created_at: :desc })

  galleries.each do |gallery|
    gallery.load_photos
    gallery.load_count_photos
    gallery.load_count_active_users
    gallery.photos.map do |photo|
      photo.load_user_info
    end
  end

  return json galleries
end

get '/galleries/:id' do
  galleries = Gallery.where id: params[:id]
  return not_found unless galleries.length > 0

  gallery = galleries.first
  photo_likes = {}

  gallery.load_photos false, current_user.id
  gallery.load_count_photos
  gallery.load_count_active_users
  gallery.photos.map do |photo|
    photo_likes[photo.id] = false
    photo.load_user_info
    photo.load_comments
    photo.comments.each do |comment|
      comment.load_user_info
    end
  end

  likes = Like.where({ photo_id: photo_likes.keys, user_id: current_user.id })
  likes.each do |like|
    photo_likes[like.photo_id] = true
  end

  gallery.photos.each do |photo|
    photo.user_has_liked = photo_likes[photo.id]
  end

  return json gallery
end

get '/galleries/:gallery_id/photos' do
  begin 
    photo_collection = GalleryPhotoCollection.new params[:gallery_id], params[:since_id]
    photo_likes = {}
    if params.has_key?('offset')
      photo_collection.photos = photo_collection.photos.limit(10).offset(params['offset'])
    end
    pick_photos = []
    photo_collection.photos.each do |photo|
      if params.has_key?('token')
        user_like_records = Like.where(user_id: current_user.id, photo_id: photo.id)
        photo.user_has_liked = user_like_records.present? ? true : false
      end  
      if photo.check_photo_flag
        photo.load_user_info
        photo.load_comments
        photo.comments.each do |comment|
          comment.load_user_info
        end
        photo.load_count_likes
        photo.load_count_comments
        pick_photos << photo
      else
        if params.has_key?('token') && (current_user.id == photo.user_id)
          photo.load_user_info
          photo.load_comments
          photo.comments.each do |comment|
            comment.load_user_info
          end
          photo.load_count_likes
          photo.load_count_comments
          pick_photos << photo
        end
      end 
    end
    status 200
    return json pick_photos
  rescue
    status 500
  end
end

post '/galleries' do
  deny_access unless current_user.access_level >= Admin.access_level

  return forbidden unless ACL.user_can_create_gallery current_user
    
  data = {
    user_id: current_user.id,
    owner_type: current_user.type,
    name: params[:name],
    description: params[:description],
    hero_image: params[:hero_image],
    location: params[:location],
    fb_user_id: params[:fb_user_id],
    fb_password: params[:fb_password],
    ig_user_id: params[:ig_user_id],
    ig_password: params[:ig_password],
    tw_user_id: params[:tw_user_id],
    tw_password: params[:tw_password],
    yt_user_id: params[:yt_user_id],
    yt_password: params[:yt_password],
    bypass_moderation: params[:bypass_moderation]
  }
  return error unless gallery = Gallery.create(data)
  gallery.load_app_credentials
  return created gallery
end

put '/galleries/:id' do
  return unauthorized unless current_user.authorized

  gallery = Gallery.find(params[:id])

  return error unless gallery.update! params
  gallery.load_app_credentials
  return created gallery
end

delete '/galleries/:id' do
  return unauthorized unless current_user.authorized

  gallery = Gallery.find(params[:id])
  
  return forbidden unless ACL.user_can_delete_gallery current_user, gallery

  begin
    gallery.photos.each do |photo|
      photo.destroy
    end
  rescue
    return error_message 'Could not delete gallery photos'
  end

  begin
    gallery.photos.each do |photo|
      photo.destroy
    end
    gallery.destroy
  rescue
    return error_message 'Could not delete gallery'
  else
    return no_content
  end
end

post '/galleries/:id/photos' do
  return unauthorized unless current_user.authorized
  return blocked unless current_user.check_active
  gallery = Gallery.find(params[:id])
  return forbidden unless ACL.user_can_post_in_gallery current_user, gallery
  data = {
    user_id: current_user.id,
    gallery_id: gallery.id,
    description: params[:description],
    photo: params[:photo],
    moderated: current_user.access_level >= Admin::access_level,
    location: params[:location],
  }
  return error unless photo = Photo.create(data)
  photo.load_user_info
  photo.load_photo_message
  photo.load_thumb params[:photo]
  return created photo
end

get '/galleries/:id/search' do
  # return unauthorized unless current_user.authorized
  photo_id = []
  gallery = Gallery.find(params[:id])
  @photo = Photo.where(gallery_id: params[:id])
  @photo_search = @photo.where('description ilike ?',  "%#{params[:search]}%")
  @comment = Comment.where(photo_id: @photo.pluck(:id)).where('text ilike ?',  "%#{params[:search]}%")
  @photo_search.map{|p| photo_id << p.id}
  @comment.map{|p| photo_id << p.photo_id}
  status 200
  return  json photo_id.uniq
end

post '/galleries/:gallery_id/photos/:photo_id/comments' do
  return unauthorized unless current_user.authorized
  return blocked unless current_user.check_active
  photos = Photo.where({ id: params[:photo_id], gallery_id: params[:gallery_id] })
  return not_found unless photos.length > 0
  photo = photos.first
  return forbidden unless ACL.user_can_comment_on_photo current_user, photo
  data = {
    user_id: current_user.id,
    photo_id: photo.id,
    text: params[:text]
  }
  return error unless comment = Comment.create(data)
  return created comment
end