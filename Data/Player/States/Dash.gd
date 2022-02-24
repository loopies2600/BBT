extends State

func enter(msg := {}):
	if owner.is_on_floor():
		owner.anim.play("Jump")
	else:
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
	
	if !owner.holding:
		owner.takeObject()
	else:
		owner.throwObject(Vector2(owner.tossForce.x, 0).rotated(angle) - Vector2(0, owner.tossForce.y))
		
func physics_update(_delta):
	if owner.is_on_floor() || owner.is_on_wall():
		owner.velocity.x = 0
		emit_signal("finished", "idle")
