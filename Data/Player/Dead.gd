extends State

const HARD_HAT = preload("res://Data/Player/Stuffs/HardHat.tscn")

func enter(msg := {}):
	var velocity := Vector2(owner.velocity.x, owner.jumpHeight * owner.upDirection.y)
	
	if msg.has("velocity"):
		velocity = msg.velocity
		
	if is_instance_valid(owner.holding):
		owner.throwObject()
	
	# spawnea el casco y aplica velocidad
	var newHat = HARD_HAT.instance()
	get_tree().get_root().add_child(newHat)
	
	newHat.global_position = owner.global_position
	newHat.velocity = Vector2(rand_range(-velocity.x, velocity.x), velocity.y * 1.25)
	newHat.upDirection = owner.upDirection
	
	# señal muerte y animar
	owner.emit_signal("died")
	owner.anim.play("Death")
	owner._doDust = true
	
	# desactivar colisiones y sacudir camara
	Global.plop(owner.global_position)
	owner.cam.shake(3, 3)
	owner.collisionBox.set_deferred("disabled", true)
	owner.canInput = false
	
	# mover
	owner.velocity = velocity
	
	# esperar y reiniciar
	yield(get_tree().create_timer(owner.resetDelay), "timeout")
	
	owner.levelManager.restart()
