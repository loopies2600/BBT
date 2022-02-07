extends SpriteMask

func _ready():
	sprite = get_parent()
	
func getTexture():
	return sprite.frames.get_frame("Idle", sprite.frame).get_data()
