extends SpriteMask

func _ready():
	sprite = get_parent()
	
func getTexture():
	var img : Image = sprite.texture.get_data()
	img = img.get_rect(sprite.region_rect)
	
	return img
