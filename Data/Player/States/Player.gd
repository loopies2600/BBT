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
onready var tools := $Tools
onready var objOffset := $Graphics/HeldObjectOffset
onready var collisionBox := $CollisionBox
onready var fsm := $StateMachine
onready var light := $Light
onready var ceilDetector := $CeilDetector
onready var cam := $Camera
onready var slideDust := $Graphics/SlideDust

var closeObj
var holding

var god := false

var grounded := false
var canInput := true
var canGetStuff := false

var levelManager

onready var bottom : int = levelManager.cam.global_position.y + 256

func _ready():
	letsStart()
	
func letsStart():
	cam.set_as_toplevel(true)
	
	# las nubecitas se ven raras, procuro desactivarlas
	_doDust = false
	
	# movemos a benito hacia lo más abajo del nivel
	global_position = Vector2(spawnPos.x, bottom)
	
	# no podemos dejar que se le aplique ninguna fuerza
	velocity = Vector2.ZERO
	
	# por ahora desactivemos la gravedad y los controles
	canInput = false
	doGravity = false
	
	# para evitar que choque con algo mientras salta
	# desactivemos su colisión
	collisionBox.set_deferred("disabled", true)
	
	# esperemos un rato
	yield(get_tree().create_timer(resetDelay / 2), "timeout")
	
	_hopIn()
	
func _process(delta):
	Main.entityLookTowards = global_position
	
	_bottomKillCheck()
	_checkNHold(delta)
	
	gfx.scale.x = dir
	
func _bottomKillCheck():
	if get_global_transform_with_canvas().origin.y > 240 && !collisionBox.disabled:
		kill({"noAnim" : true})
	
func _checkNHold(delta : float):
	closeObj = tools.findNearObjects()
	
	if is_instance_valid(holding): 
		holding.global_position = lerp(holding.global_position, objOffset.global_position, 16 * delta)
	else:
		holding = null
		weight = 1.0
	
func takeObject():
	if !closeObj: return
	
	holding = closeObj
	weight = holding.weight
	holding.set_collision_mask_bit(3, false)
	holding.doGravity = false
	
func throwObject(force := Vector2()):
	holding.velocity = force
	
	holding.doGravity = true
	holding = null
	
func _dustTrigger():
	pass
	
func kill(msg := {}):
	if god: return
	
	fsm._change_state("dead", msg)
	
func _hopIn():
	doGravity = true
	
	# necesitamos que TODO se adhiera a esto, por favor
	var distance : int = Vector2(spawnPos.x, bottom).distance_to(spawnPos)
	
	fsm._change_state("air", {"jumpHeight" : distance, "antiCancel" : true})
	
	# esperemos hasta que llegue a la punta
	yield(get_tree().create_timer(jumpDuration), "timeout")
	
	cam.position = Vector2()
	cam.set_as_toplevel(false)
	
	canInput = true
	collisionBox.set_deferred("disabled", false)
