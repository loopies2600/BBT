extends Node2D

const RANDWELCOME := ["I wonder if anyone reads these things...", "I should get paid for this", "Godot is cool :)", "Sugar free (i think)", "Video game lamps use real electricity", "Now using Newgrounds API", "I should get paid for this"]

onready var wave := $AudioStreamPlayer
onready var label := $Tones

func _ready():
	randomize()
	
	Main.cam.current = false
	Main.cam.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT

	wave.stream.loop_begin = 15785
	
	yield(_diatonic(), "completed")
	
	yield(get_tree().create_timer(2.0), "timeout")
	
	label.text = "\n* BENNETT BOY'S TROUBLE *"
	label.text += "\n2022 Loopies"
	
	yield(get_tree().create_timer(1.0), "timeout")
	
	label.text += "\n\n%s" % RANDWELCOME[randi() % RANDWELCOME.size()]
	
	yield(get_tree().create_timer(1.0), "timeout")
	
	label.text += "\n\n--- TILE LIST ---\n"
	
	for tile in Main.level.tile_set.get_tiles_ids():
		label.text += "%s, " % Main.level.tile_set.tile_get_name(tile)
		yield(get_tree().create_timer(0.025), "timeout")
		
	yield(get_tree().create_timer(4.0), "timeout")
	
	Main.changeScene(Main.TITLE)
	
func _diatonic(root := 1.0):
	label.text = "\nSequence test"
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	var pitches := [1, 1.125, 1.25, 1.33, 1.5, 1.66, 1.875, 2]
	
	for i in range(pitches.size()):
		wave.pitch_scale = pitches[i] * root
		
		wave.play()
		yield(get_tree().create_timer(0.5), "timeout")
	
	wave.stop()
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	label.text += "\n\nSound OK"
