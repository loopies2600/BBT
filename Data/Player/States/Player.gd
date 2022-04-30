extends Kinematos
class_name Player

const CONFIGURATOR = preload("res://Data/Editor/Item/Object/Neo/Objects/PlayerConfig.gd")

export (float) var accel = 100.0
export (float, 0, 1) var bounciness = 0.5
export (float, 0, 1) var airDamping = 0.98
export (float, 0, 1) var damping = 0.5
export (float) var resetDelay = 1.5
export (int) var slideStrength = 196
export (float) var slideDuration = 0.35

export (float) var rocketSpeed = 256.0
export (float) var rocketSteering = 6.0
export (float) var rocketAccel = 32.0

export (float) var wallTime = 0.5

onready var anim := $Graphics/Anim
onready var ganim := $Graphics/GAnim
onready var gfx := $Graphics
onready var collisionBox := $CollisionBox
onready var fsm := $StateMachine
onready var light := $Light
onready var ceilDetector := $Graphics/CeilDetector
onready var sounds := [$Jump, $Dash, $Slide]
onready var wallDetector := $Graphics/WallDetector
onready var bgTint := $BGTint
onready var resetTimer := $StateMachine/Dead/ResetTimer
onready var debugInfo := $BennyInfo/BIRenderer

var god := false

var iDir := 0
var grounded := false
var canInput := true
var canDash := true
var canWallJump := true

func resetState():
	.resetState()
	letsStart()
	
	if Main.editing:
		fsm._change_state("editor")
	
func _ready():
	letsStart()
	
func letsStart():
	# borrar trayectoria
	debugInfo.motionPoints = []
	
	# arreglar un bugcito!
	resetTimer.stop()
	
	# reiniciamos estado la de colisión
	collisionBox.set_deferred("disabled", false)
	
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
	var cJumpableTiles : PoolIntArray = [5, 11, 58, 71]
	
	var close := false
	 
	if ceilDetector.is_colliding():
		var col = ceilDetector.get_collider()
		
		close = true
		
		if col is TileMap:
			var tile : int = col.get_cellv(col.world_to_map(global_position) + Vector2(0, -1))
			
			if tile in cJumpableTiles:
				close = false
			else:
				close = true
		
	return close
	
func closeToWall() -> bool:
	var dashableTiles : PoolIntArray =  [5, 6, 7, 8, 11, 27, 33, 71, 83]
	
	var close := false
	 
	if wallDetector.is_colliding():
		var col = wallDetector.get_collider()
		
		close = true
		
		if col is TileMap:
			dashableTiles.append(9 if dir == 1 else 10)
			
			var tile : int = col.get_cellv(col.world_to_map(global_position) + Vector2(1 * dir, 0))
			
			if tile in dashableTiles:
				close = false
			else:
				close = true
		
	return close
	
func _physics_process(_delta):
	iDir = Tools.getInputDirection(self)
	
	Main.entityLookTowards = global_position
	
	gfx.scale.x = dir
	
	push(maxSpd * dir)
	
	if is_on_ceiling():
		ganim.play("WallCol")
	
func _dustTrigger():
	pass
	
func kill(msg := {}):
	if Main.editing: return
	if god: return
	
	fsm._change_state("dead", msg)
