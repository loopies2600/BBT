extends State

const HARD_HAT = preload("res://Data/Particles/GenericSprite.tscn")

onready var timer := $ResetTimer

func _ready():
	var _unused = timer.connect("timeout", self, "_resetTimerEnd")
	
func enter(msg := {}):
	var velocity := Vector2(owner.velocity.x, owner.jumpHeight * owner.upDirection.y * 6)
	
	if msg.has("velocity"):
		velocity = msg.velocity
		
	# spawnea el casco y aplica velocidad
	if !msg.has("noAnim"):
		var newHat = HARD_HAT.instance()
		owner.get_parent().add_child(newHat)
		
		newHat.global_position = owner.global_position
		newHat.velocity = velocity * 1.25
		newHat.upDirection = owner.upDirection
	else:
		velocity = Vector2.ZERO
		
	# señal muerte y animar
	owner.emit_signal("died")
	owner.anim.play("Death")
	owner._doDust = true
	
	# desactivar colisiones y sacudir camara
	Main.plop(owner.global_position)
	
	var shakePower := Vector2(3, 3)
	
	if msg.has("shakePower"):
		shakePower = msg.shakePower
		
	Main.cam.shake(shakePower.x, shakePower.y)
	Main.cam.target = null
	
	owner.collisionBox.set_deferred("disabled", true)
	owner.canInput = false
	
	# mover
	owner.velocity = velocity
	
	# esperar y reiniciar
	timer.start(owner.resetDelay)
	
func _resetTimerEnd():
	Main.currentScene.restart()
	owner.letsStart()
