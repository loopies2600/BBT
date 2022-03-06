extends Kinematos

export (float, 0, 1) var airDamping = 0.98
export (float, 0, 1) var bounciness = 0.48
export (float, 0, 1) var damping = 0.86

func resetState():
	.resetState()
	upDirection = Vector2.UP
	global_position = spawnPos
	
func _ready():
	add_to_group("Holdable")
	add_to_group("Pushable")
	
	spawnPos = global_position
	
func _physics_process(_delta):
	set_collision_mask_bit(3, doGravity)
	velocity.x *= damping
