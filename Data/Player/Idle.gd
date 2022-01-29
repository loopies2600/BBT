extends State

func enter(_msg := {}):
	owner.slideDownSlopes = false
	owner._doDust = false
	
	var suffix := "FromJump" if get_parent().previous_state == "air" else ""
	
	owner.anim.play("Idle" + suffix)
	
func physics_update(_delta):
	owner.velocity *= owner.damping
	
	if owner.canInput:
		if owner.tools.getInputDirection():
			emit_signal("finished", "move")
			
		if !owner.is_on_floor():
			emit_signal("finished", "air")
			
		if Input.is_action_just_pressed("jump"):
			emit_signal("finished", "air", {"jumpHeight" : owner.jumpHeight})
			
		if Input.is_action_just_pressed("attack"):
			emit_signal("finished", "attack")
			
		if Input.is_action_pressed("look_down"):
			emit_signal("finished", "crouch")
