extends State

func enter(_msg := {}):
	owner.slideDownSlopes = true
	owner._doDust = false
	
	owner.anim.play("Crouch")
	
func physics_update(_delta):
	owner.velocity *= owner.damping
	
	if owner.canInput:
		if owner.iDir && owner.iDir != owner.dir:
			owner.dir = owner.iDir
			owner.anim.play("CrouchTurn")
			yield(get_tree().create_timer(0.05), "timeout")
			owner.anim.play("Crouch")
			
		if !owner.is_on_floor():
			emit_signal("finished", "air")
			
		if !owner.wallDetector.is_colliding():
			if Input.is_action_just_pressed("attack"):
				emit_signal("finished", "slide")
			
		if !owner.closeToCeiling():
			if Input.is_action_just_pressed("jump"):
				emit_signal("finished", "air", {"jumpHeight" : owner.jumpHeight})
				
			if Input.is_action_just_released("look_down"):
				emit_signal("finished", "idle")
