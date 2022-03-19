extends Kinematos
class_name Player

export (float) var accel = 100
export (float, 0, 1) var bounciness = 0.5
export (float, 0, 1) var airDamping = 0.98
export (float, 0, 1) var damping = 0.5
export (Vector2) var tossForce = Vector2(825, 368)
export (int) var objDetectionRadius = 32
export (float) var resetDelay = 1.5
export (int) var slideStrength = 196
export (float) var slideDuration = 0.35

onready var anim := $Graphics/Anim
onready var gfx := $Graphics
onready var objOffset := $Graphics/HeldObjectOffset
onready var collisionBox := $CollisionBox
onready var fsm := $StateMachine
onready var light := $Light
onready var ceilDetector := $CeilDetector
onready var cam := $Camera
onready var slideDust := $Graphics/SlideDust
onready var sounds := [$Jump, $Dash, $Slide]
onready var wallDetector := $WallDetector

var god := false

var iDir := 0
var grounded := false
var canInput := true

func _ready():
	letsStart()
	
func letsStart():
	# activamos colisiones
	collisionBox.set_deferred("disabled", false)
	
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
	
func _physics_process(_delta):
	if Main.editing:
		fsm._change_state("editor")
		
	iDir = Tools.getInputDirection(self)
	
	Main.entityLookTowards = global_position
	
	gfx.scale.x = dir
	wallDetector.scale.x = dir
	
	push(maxSpd * dir)
	
func _dustTrigger():
	pass
	
func kill(msg := {}):
	if god: return
	
	fsm._change_state("dead", msg)
