extends AnimatedSprite

func _ready():
	play()
	
	var _unused = connect("animation_finished", self, "queue_free")
