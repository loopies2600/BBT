extends State

func enter(_msg := {}):
	owner.canDash = true
	
	Main.cam.target = owner
	
	owner.slideDownSlopes = false
	owner._doDust = false
	
	var suffix := ""
	
	match get_parent().previous_state:
		"air":
			suffix = "FromJump"
		"slide":
			suffix = "FromSlide"
		
	owner.anim.play("Idle" + suffix)
	
func physics_update(_delta):
	owner.velocity *= owner.damping
	
	var dbgDir = int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
	
	owner.position.x += dbgDir
	
	if owner.canInput:
		if owner.iDir:
			emit_signal("finished", "move")
			
		if !owner.is_on_floor():
			emit_signal("finished", "air")
			
		if Input.is_action_just_pressed("jump"):
			emit_signal("finished", "air", {"jumpHeight" : owner.jumpHeight})
			
		if Input.is_action_pressed("look_down"):
			emit_signal("finished", "crouch")
