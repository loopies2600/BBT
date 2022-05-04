extends State

const HARD_HAT = preload("res://Data/Particles/GenericSprite.tscn")

onready var timer := $ResetTimer

func _ready():
	var _unused = timer.connect("timeout", self, "_resetTimerEnd")
	
func enter(msg := {}):
	Main.ot.dmr.marks.append(p.global_position)
	
	var velocity := Vector2(p.velocity.x, p.jumpHeight * p.upDirection.y * 6)
	
	if msg.has("velocity"):
		velocity = msg.velocity
		
	# spawnea el casco y aplica velocidad
	if !msg.has("noAnim"):
		var newHat = HARD_HAT.instance()
		p.get_parent().add_child(newHat)
		
		newHat.texture = p.spr.texture
		newHat.global_position = p.global_position
		newHat.velocity = velocity * 1.25
		newHat.upDirection = p.upDirection
	else:
		velocity = Vector2.ZERO
		
	# señal muerte y animar
	p.emit_signal("died")
	p.anim.play("Death")
	p._doDust = true
	
	# desactivar colisiones y sacudir camara
	Main.plop(p.global_position)
	
	var shakePower := Vector2(3, 3)
	
	if msg.has("shakePower"):
		shakePower = msg.shakePower
		
	Main.cam.shake(shakePower.x, shakePower.y)
	Main.cam.target = null
	
	p.collisionBox.set_deferred("disabled", true)
	p.canInput = false
	
	# mover
	p.velocity = velocity
	
	# esperar y reiniciar
	timer.start(p.resetDelay)
	
func _resetTimerEnd():
	Main.currentScene.restart()
	p.letsStart()
