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

export (Texture) var texture = preload("res://Sprites/Player/BB.png")

onready var anim := $Graphics/Anim
onready var ganim := $Graphics/GAnim
onready var gfx := $Graphics
onready var collisionBox := $CollisionBox
onready var light := $Light
onready var ceilDetector := $Graphics/CeilDetector
onready var sounds := [$JumpSnd, $DashSnd, $SlideSnd]
onready var wallDetector := $Graphics/WallDetector
onready var bgTint := $BGTint
onready var resetTimer := $Dead/ResetTimer
onready var debugInfo := $BennyInfo/BIRenderer
onready var states := [$Idle, $Crouch, $Move, $Air, $Dash, $Dead, $Slide, $Editor, $Win, $Rocket, $Walled, $Gaze]
onready var spr := $Graphics/Sprite

var state : State
var prevState := ""

var god := false

var iDir := 0
var grounded := false
var canInput := true
var canDash := true
var canWallJump := true

func setState(id, msg := {}):
	state.exit()
	prevState = state.name
	
	state = states[id]
	
	state.enter(msg)
	
func resetState():
	.resetState()
	letsStart()
	
	if Main.editing:
		setState(7)
	
func _ready():
	spr.texture = texture
	
	state = states[7]
	state.enter()
	
	var _unused = get_tree().connect("files_dropped", self, "_fileDrop")
	
func _fileDrop(files, _screen):
	var valid : bool= files[0].ends_with("png") || files[0].ends_with("jpg")
	
	if !valid: return
	
	_setTexture(files[0])
	
func _setTexture(path := ""):
	var img = Image.new()
	var error = img.load(path)
	
	if error != OK: return
	
	img.compress(Image.COMPRESS_S3TC, Image.COMPRESS_SOURCE_GENERIC, 1.0)
	
	var tex = ImageTexture.new()
	tex.create_from_image(img, 0)
	
	texture = tex
	spr.texture = tex
	
func letsStart():
	# borrar trayectoria
	debugInfo.motionPoints = []
	
	# arreglar un bugcito!
	resetTimer.stop()
	
	# reiniciamos estado la de colisión
	collisionBox.set_deferred("disabled", false)
	
	# por favor!
	canInput = true
	
	# estado: idle
	setState(0)
	
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
	
func _process(delta):
	state.update(delta)
	
func _input(event):
	state.handle_input(event)
	
func _physics_process(delta):
	state.physics_update(delta)
	
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
	
	setState(5, msg)
