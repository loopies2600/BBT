extends Node

const PLAYER := preload("res://Data/Scenes/PlayScene.tscn")
const EDITOR := preload("res://Data/Scenes/EditorScene.tscn")

const NG := preload("res://Data/Util/Newgrounds.tscn")

var editing := false

onready var cursor := $MouseCursorLayer/MouseCursorRenderer
onready var level : TileMap = preload("res://Data/Level/Level.tscn").instance()

func _ready():
	add_child(level)
	
func plop(pos := Vector2(), rotations := [0, 45, 90, 135, 180, 225, 270, 315]):
	for i in range(rotations.size()):
		var dust = load("res://Data/Particles/FastDust.tscn").instance()
	
		get_tree().get_root().add_child(dust)
		dust.global_position = pos
		dust.gravity = 4
		dust.velocity = Vector2(0, -75).rotated(deg2rad(rotations[i]))
	
func playLevel():
	get_tree().change_scene_to(PLAYER)
	
	yield(get_tree(), "idle_frame")
	get_tree().get_current_scene().setup()
	
func edit():
	get_tree().change_scene_to(EDITOR)
	
func _input(event):
	if event is InputEventKey && event.is_pressed() && !event.is_echo():
		if event.scancode == KEY_F9:
			if get_tree().get_current_scene().name == "EditorScene":
				get_tree().change_scene("res://Data/Scenes/NewgroundsChecker.tscn")
			else:
				get_tree().change_scene("res://Data/Scenes/EditorScene.tscn")
