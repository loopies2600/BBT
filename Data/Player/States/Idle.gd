extends State

func enter(_msg := {}):
	owner.canDash = true
	owner.canWallJump = true
	
	Main.cam.target = owner
	
	owner.slideDownSlopes = false
	owner._doDust = false
	
	owner.anim.play("Idle")
	
func physics_update(_delta):
	owner.velocity *= owner.damping
	
	if owner.canInput:
		if owner.iDir:
			emit_signal("finished", "move")
			
		if !owner.is_on_floor():
			emit_signal("finished", "air")
			
		if Input.is_action_just_pressed("jump"):
			emit_signal("finished", "air", {"jumpHeight" : owner.jumpHeight})
			
		if Input.is_action_just_pressed("look_up"):
			emit_signal("finished", "look_up")
			
		if Input.is_action_pressed("look_down"):
			emit_signal("finished", "crouch")
