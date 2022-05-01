extends Kinematos

const ANGRYTILE := preload("res://Data/Enemy/Midget/AngryTile.tscn")
const CONFIGURATOR := preload("res://Data/Editor/Item/Object/Neo/Objects/MidgetConfig.gd")

export (int) var tileSearchRadius = 4
export (int) var detectionRadius = 256
export (float) var seekDelay = 1.0
export (float) var tossDelay = 1.0
export (int) var tileSpeed = 512

onready var anim := $Animator
onready var seekTimer := $SeekTimer
onready var tossTimer := $TossTimer

var target : Player = null setget _setTarget
var curAT
var atVel := Vector2()

var drawGizmos := false

func _setTarget(newTgt : Player):
	if target == newTgt: return
	
	target = newTgt
	tossTimer.start(tossDelay)
	
func _ready():
	var _unused = seekTimer.connect("timeout", self, "_seek")
	_unused = tossTimer.connect("timeout", self, "_toss")
	
	doGravity = false
	
func resetState():
	.resetState()
	anim.play("Idle")
	
	seekTimer.stop()
	tossTimer.stop()
	
	if Main.editing: return
	
	seekTimer.start(seekDelay)
	
func _physics_process(_delta):
	if is_on_floor():
		velocity.x *= 0.4
		
	target = _findPlayer()
	
	if target: atVel = Vector2(tileSpeed, 0).rotated(((target.global_position + Vector2(0, 8)) - global_position).angle())
	
	if Main.editing:
		velocity = Vector2()
		return
	
func _seek():
	anim.play("Hold")
	
	randomize()
	
	var tiles : PoolVector2Array = Main.level.getTilesInRadius(((global_position + Vector2(8, 8)) / 16).round(), tileSearchRadius)
	
	var myGround := Main.level.world_to_map(global_position) + Vector2(0, 1)
	var clearThose : PoolIntArray = []
	
	for t in range(0, tiles.size()):
		if tiles[t] == myGround: clearThose.append(t)
		
	for ct in clearThose:
		tiles.remove(ct)
		
	if tiles:
		var tgtTile : Vector2 = tiles[rand_range(0, tiles.size() - 1)]
		
		if tgtTile.y == round(global_position.y / 16) + 1:
			tgtTile = tiles[rand_range(0, tiles.size() - 1)]
			
		_spawnAngryTile(tgtTile)
		Main.level.set_cellv(tgtTile, -1)
		
		if target:
			tossTimer.start(tossDelay)
	
func _findPlayer() -> Player:
	var tgt : Player
	
	var shape = CircleShape2D.new()
	shape.radius = detectionRadius
	
	var spaceState := get_world_2d().direct_space_state
	var query := Physics2DShapeQueryParameters.new()
	
	query.set_shape(shape)
	query.collision_layer = collision_layer
	query.transform = Transform2D(Vector2(1, 0), Vector2(0, 1), self.global_position + Vector2(8, 0))
	
	var result := spaceState.intersect_shape(query)
	
	if result:
		for r in result:
			var col = r.collider
			
			if col is Player:
				tgt = col
				
	return tgt
	
func _spawnAngryTile(cellPos := Vector2()):
	var id := Main.level.get_cellv(cellPos)
	
	curAT = ANGRYTILE.instance()
	
	curAT.texture = Main.level.tile_set.tile_get_texture(id)
	curAT.region_rect = Main.level.tile_set.tile_get_region(id)
	curAT.targetPos = global_position + Vector2(10, -20)
	curAT.global_position = Vector2(8, 8) + cellPos * 16
	curAT.add_to_group("Instances")
	curAT.colLayer = collision_layer
	
	Main.level.add_child(curAT)
	
func _toss():
	anim.play("Toss")
	
	curAT.snap = false
	curAT.velocity = atVel
	
	seekTimer.start(seekDelay)
	
	yield(anim, "animation_finished")
	anim.play("Idle")
