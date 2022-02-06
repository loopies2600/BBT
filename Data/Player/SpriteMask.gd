extends Light2D

onready var sprite := get_parent().get_node("Sprite")

func _texGen():
	var img : Image = sprite.texture.get_data()
	img = img.get_rect(sprite.region_rect)
	
	img.lock()
	
	# Apply hacky-ass dithering
	for pX in range(img.get_size().x):
		for pY in (img.get_size().y):
			if pX % 2 == 0:
				img.set_pixel(pX, pY, Color(0.0, 0.0, 0.0, 0.0))
				
			if pY % 2 != 0:
				img.set_pixel(pX, pY, Color(0.0, 0.0, 0.0, 0.0))
				
	img.unlock()
	
	var imgTex = ImageTexture.new()
	imgTex.create_from_image(img)
	
	return imgTex
	
func _process(_delta):
	texture = _texGen()
	
	offset.x = 8 * get_parent().scale.x
