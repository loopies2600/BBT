extends Node2D

const RANDWELCOME := ["I wonder if anyone reads these things...", "I should get paid for this", "Godot is cool :)", "Sugar free (i think)", "Video game lamps use real electricity", "Now using Newgrounds API", "I should get paid for this"]

onready var label := $Tones

var timer := 0.0
var playing := false
var song := []


func _ready():
	randomize()
	
	Main.ot.setTouchControls(false)
	Main.cam.current = false
	Main.cam.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	label.text = "\n* BENNETT BOY'S TROUBLE *"
	
	yield(get_tree().create_timer(0.5), "timeout")
	label.text += "\n2022 Loopies"
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	label.text += "\n\n%s" % RANDWELCOME[randi() % RANDWELCOME.size()]
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	label.text += "\n\n--- TILE LIST ---\n"
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	for tile in Main.level.tile_set.get_tiles_ids():
		label.text += "%s, " % Main.level.tile_set.tile_get_name(tile)
		yield(get_tree().create_timer(0.025), "timeout")
		
	yield(get_tree().create_timer(4.0), "timeout")
	
	Main.changeScene(Main.TITLE)
