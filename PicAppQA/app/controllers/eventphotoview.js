var args = arguments[0] || {},
	item = args.item;

try {
	$.img.image = item.file_url;
	$.useravatar.image = item.user_profile_image;

	$.name.text = item.user_name;
	$.name2.text = item.user_name;
	$.desc.text = item.description;

	$.flagphotoview.opacity = item.flagged ? "1" : "0.5";
	
	if(item.user_has_liked)
		$.likeimg.image="/images/icons/like_sel.png";
	else
		$.likeimg.image="/images/icons/like.png";
} catch(exception) {
	Ti.API.error("EventPhotoView error: " + JSON.stringify(exception));
}