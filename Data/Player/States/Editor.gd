extends State

func enter(_msg := {}):
	owner.anim.play("Wait")
	owner.global_position = owner.spawnPos
	
func physics_update(_delta):
	owner.dir = 1
	
	if !Main.editing:
		emit_signal("finished", "idle")
	
func exit():
	owner.spawnPos = owner.global_position
