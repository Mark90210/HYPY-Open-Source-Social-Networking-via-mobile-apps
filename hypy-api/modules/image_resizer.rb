module Image_Resizer # include me

	@@sizes = {
		thumb: 120,
		normal: 360,
		large: 1080
	}

	def resize input, size=:normal
		image = MiniMagick::Image.new(input[:tempfile].path)
		size = @@sizes[size]
		image.resize size.to_s
		input
	end

end