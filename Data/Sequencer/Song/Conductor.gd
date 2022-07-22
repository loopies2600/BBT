extends Node

onready var channels := [$Ch0, $Ch1, $Ch2, $Ch3, $Ch4, $Ch5, $Ch6, $Ch7]

var playing := false
var timer := 0.0

static func sortNotes(a, b):
	if a.time < b.time:
		return true
		
	return false
	
func _process(delta):
	if playing:
		timer += delta
		
		for c in channels:
			for note in c.song:
				if note.time - timer < 0.05:
					c.streamer.pitch_scale = note.pitch
					c.play()
					c.song.pop_front()
