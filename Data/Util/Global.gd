extends Node

var editing := false

func plop(pos := Vector2(), rotations := [0, 45, 90, 135, 180, 225, 270, 315]):
	for i in range(rotations.size()):
		var dust = load("res://Data/Particles/FastDust.tscn").instance()
	
		get_tree().get_root().add_child(dust)
		dust.global_position = pos
		dust.gravity = 4
		dust.velocity = Vector2(0, -75).rotated(deg2rad(rotations[i]))
	
func playLevel(level : PackedScene):
	get_tree().change_scene("res://Data/Scenes/PlayScene.tscn")
	yield(get_tree(), "idle_frame")
	
	get_tree().get_current_scene().level = level
	get_tree().get_current_scene().setup()
	
func edit(level : PackedScene):
	get_tree().change_scene("res://Data/Scenes/EditorScene.tscn")
	yield(get_tree(), "idle_frame")
	
	var newLvl = level.instance()
	newLvl.firstRun = false
	
	get_tree().get_current_scene().get_node("LevelLayout").queue_free()
	yield(get_tree(), "idle_frame")
	get_tree().get_current_scene().add_child(newLvl)
	get_tree().get_current_scene().level = newLvl
	
	for c in newLvl.get_children():
		c.add_to_group("Instances")
