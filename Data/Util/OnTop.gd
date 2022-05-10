extends CanvasLayer

const MONITOR := preload("res://Data/Object/TimerMonitor/TimerMonitor.tscn")

onready var dmr := $DeathMarkerRenderer
onready var ti := $TokenIcons

var _blockTimer = null

onready var _sTime := OS.get_ticks_msec()
var lvlTime := 0

func reset(_mode := 0):
	_sTime = OS.get_ticks_msec()
	
	if !_blockTimer: return
	
	_blockTimer.queue_free()
	_blockTimer = null
	
func _process(delta):
	if Main.editing: return
	
	lvlTime = OS.get_ticks_msec() - _sTime
	
func _spawnBlockTimer():
	if _blockTimer: return
	
	_blockTimer = MONITOR.instance()
	
	_blockTimer.global_position = Vector2(208, 32)
	_blockTimer.connect("tree_exited", self, "_monFree")
	_blockTimer.isTimer = true
	
	add_child(_blockTimer)
	
func _monFree():
	_blockTimer = null
