extends SpriteMask

func _ready():
	sprite = get_parent()
	
func getTexture():
	return sprite.texture.get_data()
