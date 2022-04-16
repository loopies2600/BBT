extends Node

# warning-ignore:unused_signal
signal game_mode_changed(mode)
signal scene_changed()
signal level_changed()
signal level_saved()

const TITLE := preload("res://Data/Scenes/Title.tscn")
const EDITOR := preload("res://Data/Scenes/LevelEditor.tscn")
const NGIOSTATUS := preload("res://Data/Scenes/NewgroundsChecker.tscn")
const NG := preload("res://Data/Util/Newgrounds.tscn")

const DUST := preload("res://Data/Particles/FastDust.tscn")
const EANIM := preload("res://Data/Particles/DustExplosion.tres")

var editing := true

onready var cam := $Camera
onready var hud := $HUD
onready var level : TileMap = preload("res://Data/Level/Level.tscn").instance()
onready var olr := $OptimalLightRenderer/LightVP/BG

var currentScene

var attempt := 1

var entityLookTowards := Vector2()

func setNewLevel():
	var newLvl = Tools.openFilePicker()
	
	if OS.get_name() == "HTML5":
		emit_signal("level_changed")
		return
		
	if newLvl:
		reload(newLvl)
		emit_signal("level_changed")
		
func saveLevel():
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	if OS.get_name() == "HTML5":
		level.saveLvl("user:/", "temp.tscn")
		
		var temp := File.new()
# warning-ignore:return_value_discarded
		temp.open("user://temp.tscn", File.READ)
		var buffer = PoolByteArray(temp.get_buffer(temp.get_len()))
		
		temp.close()
		
		WebFiles.save_file("level.tscn", buffer, "text/plain")
		
		emit_signal("level_saved")
		return
		
	var path : String = Tools.openFolderPicker()
	
	if path:
		level.saveLvl(path)
		emit_signal("level_saved")
		
func reload(newLvl : PackedScene):
	currentScene.queue_free()
	currentScene = null
	
	level.queue_free()
	level = null
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	level = newLvl.instance()
	
	_levelInit(level)
	
func _ready():
	_levelInit(level)
	
	changeScene(TITLE)
	
func _levelInit(lev):
	add_child(lev)
	
	changeScene(EDITOR)
	
func plop(pos := Vector2(), rotations := [0, 45, 90, 135, 180, 225, 270, 315]):
	for i in range(rotations.size()):
		var dust = DUST.instance()
		
		dust.frames = EANIM
		
		level.add_child(dust)
		dust.global_position = pos
		dust.gravity = 4
		dust.velocity = Vector2(0, -75).rotated(deg2rad(rotations[i]))
	
func changeScene(packedScene):
	var newScene = packedScene.instance()
	
	if currentScene:
		currentScene.call_deferred("queue_free")
		currentScene = null
		
	currentScene = newScene
	call_deferred("add_child", newScene)
	
	emit_signal("scene_changed")
	
func _input(event):
	if event is InputEventKey && event.is_pressed() && !event.is_echo():
		if event.scancode == KEY_F9:
			if currentScene.name == "LevelEditor":
				changeScene(NGIOSTATUS)
			else:
				changeScene(EDITOR)
	
func getNodeOnThisPos(pos := Vector2()) -> Node2D:
	var node
	
	for c in get_tree().get_nodes_in_group("Instances"):
		if (c.global_position / level.cell_size / level.scale).round() == pos:
			node = c
	
	return node
