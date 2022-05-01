extends State

func enter(msg := {}):
	owner.canWallJump = true
	
	owner.sounds[1].play()
	owner.anim.play("Dash")
	
	owner._doDust = true
	
	var left := int(Input.is_action_pressed("left"))
	var right := int(Input.is_action_pressed("right"))
	var up := int(Input.is_action_pressed("look_up"))
	var down := int(Input.is_action_pressed("look_down"))
	
	var angle := Vector2(right - left, down - up).angle()
	
	if angle == 0.0: angle = 0.0 if owner.dir == 1 else PI
	
	if !msg.has("noBoost"):
		owner.velocity = Vector2((owner.maxSpd * 2) / owner.weight, 0).rotated(angle)
	
func physics_update(_delta):
	if owner.get_slide_count():
		owner.velocity.x = 0
		emit_signal("finished", "air")
