get '/photos/:id' do
  return unauthorized unless current_user.authorized

  photo = Photo.find params[:id]
  photo.load_user_info
  photo.load_comments
  photo.load_count_likes
  photo.user_has_liked = Like.exists? user_id: current_user.id, photo_id: photo.id

  photo.comments.each do |comment|
    comment.load_user_info
  end

  return json photo
end

get '/photos/:id/download' do
  return unauthorized unless current_user.authorized

  photo = Photo.find params[:id]
  photo.load_user_info
  photo.load_comments
  photo.load_count_likes
  photo.user_has_liked = Like.exists? user_id: current_user.id, photo_id: photo.id

  photo.comments.each do |comment|
    comment.load_user_info
  end

  return json photo
end

post '/photos/:id/likes' do
  return unauthorized unless current_user.authorized
  return blocked unless current_user.check_active
  photo = Photo.find params[:id]
  return forbidden unless ACL.user_can_like_photo current_user, photo
  data = {
  	user_id: current_user.id,
  	photo_id: photo.id
  }
  like = Like.find_or_create data
  return created like
end

get '/photos/:id/likes' do
  likes = []
  like_records = Like.where(photo_id: params[:id])
   like_records.each do |like|
    like.load_user_info
    likes << like
   end
  return json likes
end  

post '/photos/:id/flag' do
  return unauthorized unless current_user.authorized 

  photo = Photo.find params[:id]

  # return forbidden unless ACL.user_can_flag_photo current_user, photo

  data = {
    user_id: current_user.id,
    photo_id: photo.id
  }

  flag = PhotoFlag.find_or_create data

  return created flag
end

post '/photos/:photo_id/comments/:comment_id/flag' do
  return unauthorized unless current_user.authorized

  photo = Photo.find params[:photo_id]
  comment = Comment.find params[:comment_id]

  return forbidden unless ACL.user_can_flag_photo_comment current_user, photo

  data = {
    user_id: current_user.id,
    comment_id: comment.id
  }
  flag = CommentFlag.find_or_create data

  return created flag
end