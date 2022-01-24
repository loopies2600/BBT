extends State

func enter(_msg := {}):
	owner.anim.play("Dash")
	
	owner._doDust = true
	
	var left := int(Input.is_action_pressed("left"))
	var right := int(Input.is_action_pressed("right"))
	var up := int(Input.is_action_pressed("look_up"))
	var down := int(Input.is_action_pressed("look_down"))
	
	var angle := Vector2(right - left, down - up).angle()
	
	if angle == 0: angle = 0 if owner.dir == 1 else PI
	
	owner.velocity = Vector2((owner.maxSpd * 2) / owner.weight, 0).rotated(angle)
	
	if !owner.holding:
		owner.takeObject()
	else:
		owner.throwObject(Vector2(owner.tossForce.x, 0).rotated(angle) - Vector2(0, owner.tossForce.y))
		
func physics_update(_delta):
	owner.velocity.y += owner.gravity * -owner.upDirection.y * (owner.fallMult if sign(owner.velocity.y) == 1 else 1)
	
	if owner.is_on_floor():
		emit_signal("finished", "idle")
