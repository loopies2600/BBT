extends Kinematos

export (float, 0, 1) var airDamping = 0.98
export (float, 0, 1) var bounciness = 0.48
export (float, 0, 1) var damping = 0.86
export (float) var weight = 1.5

func resetState():
	upDirection = Vector2.UP
	global_position = spawnPos
	velocity = Vector2()
	
func _ready():
	add_to_group("Holdable")
	add_to_group("Pushable")
	
	spawnPos = global_position
	
func _physics_process(delta):
	if Global.editing: 
		velocity = Vector2()
		return
	
	if doGravity:
		velocity.y += gravity * -upDirection.y
	
	velocity = move_and_slide(velocity, upDirection)
	
	_checkSlides()
	
func _checkSlides():
	for c in get_slide_count():
		var collision := get_slide_collision(c)
	
		if collision:
			if collision.collider.get("velBoost"):
				velocity = collision.collider.velBoost
				
			if doGravity:
				set_collision_mask_bit(3, true)
				
			var normal := collision.normal
			
			velocity = velocity.bounce(normal)
			velocity *= bounciness
		
