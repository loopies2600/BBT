extends State

func enter(_msg := {}):
	Main.cam.target = null
	
	owner.velocity = Vector2.ZERO
	owner.doGravity = false
	owner.anim.play("Wait")
	owner.global_position = owner.spawnPos
	
func physics_update(_delta):
	owner.velocity *= owner.damping
	
	owner.dir = 1
	
	if !Main.editing:
		emit_signal("finished", "idle")
	
func exit():
	owner.doGravity = true
	owner.spawnPos = owner.global_position
