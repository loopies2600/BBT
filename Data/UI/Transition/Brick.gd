extends Sprite

export (int) var gravity = 96
export (int) var floorY = 208

var velocity := Vector2()

func _ready():
	global_position.y = -32

func _physics_process(delta):
	if global_position.y < floorY:
		velocity.y += gravity
	else:
		velocity.y = 0
		global_position.y = lerp(global_position.y, floorY, 16 * delta)
	
	position += velocity * delta
