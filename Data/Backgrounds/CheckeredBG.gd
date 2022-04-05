extends TextureRect

export (Vector2) var speed = Vector2(-32, -32)
export (bool) var timedFlip = true
export (float) var flipTime = 2.0
export (int) var flipOffset = 32

func _ready():
	texture = texture.duplicate()
	
	if timedFlip:
		_tLoop()
	
func _tLoop():
	yield(get_tree().create_timer(flipTime), "timeout")
	texture.region.position.y += flipOffset
	_tLoop()
	
func _process(delta):
	texture.region.position += Vector2(1, 1).normalized() * speed * delta
