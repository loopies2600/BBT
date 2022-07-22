extends CanvasLayer

const MONITOR := preload("res://Data/Object/TimerMonitor/TimerMonitor.tscn")
const LEVELCARD := preload("res://Data/UI/LevelCard.tscn")

onready var dmr := $DeathMarkerRenderer
onready var li := $LevelInfo
onready var lvp := $LightVP
onready var light := $Light
onready var touchCtl := $OverEverything/TouchControls

var _blockTimer = null
var _card = null

onready var _sTime := OS.get_ticks_msec()
var lvlTime := 0

func setTouchControls(booly := true):
	touchCtl.visible = booly
	
func deleteTimer():
	if _blockTimer:
		_blockTimer.queue_free()
		_blockTimer = null
	
func reset(mode := 0):
	_sTime = OS.get_ticks_msec()
	
	deleteTimer()
	
	if !_card:
		if mode == 0:
			_card = LEVELCARD.instance()
			
			_card.connect("tree_exited", self, "_crdFree")
			_card.global_position = Vector2(213, -32)
			
			add_child(_card)
	else:
		_card.queue_free()
		_card = null
	
func _process(_delta):
	light.texture = lvp.get_texture()
	
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

func _crdFree():
	_card = null
