extends AudioStreamPlayer

var song := []

class SequenceNote:
	var sampleID := 0
	var pitch := 1.0
	var volume := 1.0
	var time := 0.0
	
	func _init(t, p):
		time = t
		pitch = p
