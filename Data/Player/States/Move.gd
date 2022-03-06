extends State

func enter(_msg := {}):
	if owner.iDir != owner.dir:
		owner.anim.play("Turn")
		yield(owner.anim, "animation_finished")
		owner.anim.play("Walk")
		
	owner.anim.play("Walk")
	
func physics_update(_delta):
	owner.velocity.x = clamp(owner.velocity.x + owner.accel * owner.iDir, -owner.maxSpd, owner.maxSpd) / owner.weight
	owner.velocity.x *= abs(owner.get_floor_normal().y)
	
	if owner.canInput:
		if !owner.iDir:
			emit_signal("finished", "idle")
		else:
			owner.dir = owner.iDir
			
		if !owner.is_on_floor():
			emit_signal("finished", "air")
		
		if !owner.ceilDetector.is_colliding():
			if Input.is_action_just_pressed("jump"):
				emit_signal("finished", "air", {"jumpHeight" : owner.jumpHeight})
			
			if Input.is_action_just_pressed("attack"):
				emit_signal("finished", "dash")
			
		if Input.is_action_just_pressed("look_down"):
			emit_signal("finished", "crouch")
