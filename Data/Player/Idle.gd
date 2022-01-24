extends State

func enter(_msg := {}):
	owner._doDust = false
	
	var suffix := "FromJump" if get_parent().previous_state == "air" else ""
	
	if owner.velocity.y > 600.0:
		owner.spawnFeetDust()
		
	owner.anim.play("Idle" + suffix)
	
func physics_update(delta):
	owner.velocity *= owner.damping
	
	if owner.canInput:
		if owner.tools.getInputDirection():
			emit_signal("finished", "move")
			
		if !owner.is_on_floor():
			emit_signal("finished", "air")
			
		if Input.is_action_just_pressed("jump"):
			emit_signal("finished", "air", {"isJump" : true})
			
		if Input.is_action_just_pressed("attack"):
			emit_signal("finished", "dash")
