extends AnimatedSprite

const ANIMSPEED := 0.4

var startPos := Vector2()
var midPos := Vector2()
var endPos := Vector2()

var _time := 0.0

func _ready():
	midPos = lerp(startPos, endPos, 0.5) + Vector2(128, 128)
	
func _process(delta):
	_time += delta / ANIMSPEED
	
	if _time > 1.0:
		queue_free()
	
	global_position = Math.quadBezier(startPos, midPos, endPos, _time)
	
