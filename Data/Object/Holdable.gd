extends Kinematos

export (float, 0, 1) var airDamping = 0.98
export (float, 0, 1) var bounciness = 0.48
export (float, 0, 1) var damping = 0.86
export (float) var weight = 1.5

func resetState():
	global_position = spawnPos
	
func _ready():
	add_to_group("Holdable")
	add_to_group("Pushable")
	
	spawnPos = global_position
	
func _physics_process(delta):
	if Global.editing: return
	
	if doGravity:
		velocity.y += gravity * -upDirection.y
	
	var collision := move_and_collide(velocity * delta)
	
	velocity.x *= damping if is_on_floor() else airDamping
	
	if collision:
		if doGravity:
			set_collision_mask_bit(3, true)
			
		var normal := collision.normal
		
		velocity = velocity.bounce(normal)
		velocity *= bounciness
	
