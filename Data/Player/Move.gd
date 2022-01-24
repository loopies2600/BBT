extends State

func physics_update(delta):
	owner.velocity.x = clamp(owner.velocity.x + owner.accel * owner.tools.getInputDirection(), -owner.maxSpd, owner.maxSpd) / owner.weight
	
	if owner.canInput:
		if !owner.tools.getInputDirection():
			emit_signal("finished", "idle")
		else:
			owner.anim.play("Walk")
			owner.dir = owner.tools.getInputDirection()
			
		if !owner.is_on_floor():
			emit_signal("finished", "air")
		
		if Input.is_action_just_pressed("jump"):
			emit_signal("finished", "air", {"isJump" : true})
		
		if Input.is_action_just_pressed("attack"):
			emit_signal("finished", "dash")
			
	if owner.is_on_wall():
		owner.velocity.x = 0
	
