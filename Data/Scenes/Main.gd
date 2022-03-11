extends Node

const PLAYER := preload("res://Data/Scenes/PlayerScene.tscn")
const NGIOSTATUS := preload("res://Data/Scenes/NewgroundsChecker.tscn")
const NG := preload("res://Data/Util/Newgrounds.tscn")

var editing := true

onready var hud := $HUD
onready var background := $ImageBG
onready var level : TileMap = preload("res://Data/Level/Level.tscn").instance()

var currentScene

var attempt := 1

var entityLookTowards := Vector2()

func _ready():
	var newLvl = Tools.openFilePicker()
	
	if newLvl:
		level = newLvl.instance()
		
	_levelInit(level)
	
func _levelInit(lev):
	add_child(lev)
	
	changeScene(PLAYER)
	
func plop(pos := Vector2(), rotations := [0, 45, 90, 135, 180, 225, 270, 315]):
	for i in range(rotations.size()):
		var dust = load("res://Data/Particles/FastDust.tscn").instance()
	
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
	
func _input(event):
	if event is InputEventKey && event.is_pressed() && !event.is_echo():
		if event.scancode == KEY_F9:
			if currentScene.name == "PlayScene":
				changeScene(NGIOSTATUS)
			else:
				changeScene(PLAYER)
