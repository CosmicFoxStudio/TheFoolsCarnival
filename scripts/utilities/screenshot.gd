extends TextureRect


func take_screenshot() -> Texture2D:
	var viewport_size = get_viewport().size
	var viewport_w = viewport_size.x
	var viewport_h = viewport_size.y
	
	var img = get_viewport().get_texture().get_image()
	img.resize(viewport_w,viewport_h)
	
	var screenshot = ImageTexture.create_from_image(img)
	texture = screenshot
	return screenshot
