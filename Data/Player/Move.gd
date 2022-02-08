extends State

func enter(_msg := {}):
	owner.anim.play("Walk")
	
func physics_update(_delta):
	owner.velocity.x = clamp(owner.velocity.x + owner.accel * owner.tools.getInputDirection(), -owner.maxSpd, owner.maxSpd) / owner.weight
	owner.velocity.x *= abs(owner.get_floor_normal().y)
	
	if owner.canInput:
		if !owner.tools.getInputDirection():
			emit_signal("finished", "idle")
		else:
			owner.dir = owner.tools.getInputDirection()
			
		if !owner.is_on_floor():
			emit_signal("finished", "air")
		
		if !owner.ceilDetector.is_colliding():
			if Input.is_action_just_pressed("jump"):
				emit_signal("finished", "air", {"jumpHeight" : owner.jumpHeight})
			
			if Input.is_action_just_pressed("attack"):
				emit_signal("finished", "attack")
			
		if Input.is_action_just_pressed("look_down"):
			emit_signal("finished", "crouch")
