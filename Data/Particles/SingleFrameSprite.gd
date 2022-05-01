extends Sprite

func _ready():
	yield(get_tree(), "idle_frame")
	queue_free()
