class ACL

	def self.user_can_interact_with_user acting_user, target_user
		true
	end

	def self.user_owns_gallery user, gallery
		user.id == gallery.user_id
	end

	def self.user_can_create_gallery user
		true
	end

	def self.user_can_interact_with_gallery user, gallery
		true
	end


	def self.user_can_interact_with_photo user, photo
		true
	end

	class << self
		alias user_can_view_user user_can_interact_with_user

		alias user_can_delete_gallery user_owns_gallery
		alias user_can_update_gallery user_owns_gallery

		alias user_can_contribute_to_gallery user_can_interact_with_gallery
		alias user_can_post_in_gallery user_can_interact_with_gallery

		alias user_can_like_photo user_can_interact_with_photo
		alias user_can_flag_photo user_can_interact_with_photo
		alias user_can_comment_on_photo user_can_interact_with_photo
		alias user_can_flag_photo_comment user_can_interact_with_photo
	end

end