extends Kinematos
class_name Player

export (float) var accel = 100.0
export (float, 0, 1) var bounciness = 0.5
export (float, 0, 1) var airDamping = 0.98
export (float, 0, 1) var damping = 0.5
export (Vector2) var tossForce = Vector2(825, 368)
export (int) var objDetectionRadius = 32
export (float) var resetDelay = 1.5
export (int) var slideStrength = 196
export (float) var slideDuration = 0.35

export (float) var rocketSpeed = 256.0
export (float) var rocketSteering = 6.0
export (float) var rocketAccel = 32.0

onready var anim := $Graphics/Anim
onready var ganim := $Graphics/GAnim
onready var gfx := $Graphics
onready var objOffset := $Graphics/HeldObjectOffset
onready var collisionBox := $CollisionBox
onready var fsm := $StateMachine
onready var light := $Light
onready var ceilDetector := $Graphics/CeilDetector
onready var sounds := [$Jump, $Dash, $Slide]
onready var wallDetector := $Graphics/WallDetector
onready var bgTint := $BGTint

var god := false

var iDir := 0
var grounded := false
var canInput := true

func resetState():
	letsStart()
	
	if Main.editing:
		fsm._change_state("editor")
	
func _ready():
	letsStart()
	
func letsStart():
	# reiniciamos estado la de colisión
	collisionBox.set_deferred("disabled", false)
	
	# reiciamos gravedad
	upDirection = Vector2.UP
	
	# reiniciamos posición
	global_position = spawnPos
	
	# las nubecitas se ven raras, procuro desactivarlas
	_doDust = false
	canInput = true
	
	# no podemos dejar que se le aplique ninguna fuerza
	velocity = Vector2.ZERO
	
	# por ahora desactivemos la gravedad y los controles
	upDirection = Vector2.UP
	
	# estado: idle
	fsm._change_state("idle")
	
func closeToCeiling() -> bool:
	var close := false
	 
	if ceilDetector.is_colliding():
		var col = ceilDetector.get_collider()
		
		if col is TileMap:
			var tile : int = col.get_cellv((global_position / 16).round() + Vector2(0, -1))
			
			if tile in [5, 11, 71]:
				close = false
			else:
				close = true
		
	return close
	
func _physics_process(_delta):
	iDir = Tools.getInputDirection(self)
	
	Main.entityLookTowards = global_position
	
	gfx.scale.x = dir
	
	push(maxSpd * dir)
	
func _dustTrigger():
	pass
	
func kill(msg := {}):
	if god: return
	
	fsm._change_state("dead", msg)
