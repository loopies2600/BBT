extends CanvasLayer

signal transition_ended()

const BRICK := preload("res://Data/UI/Transition/Brick.tscn")

export (float) var delay := 0.025
export (float) var endDelay := 0.5

func _ready():
	yield(_spawnBricks(), "completed")
	yield(get_tree().create_timer(endDelay), "timeout")
	
	emit_signal("transition_ended")
	yield(_sendBricksOffscreen(), "completed")
	yield(get_tree().create_timer(endDelay), "timeout")
	
	queue_free()
	
func _spawnBricks():
	var y := 208
	
	for i in range(8):
		for t in range(8):
			var x : int = 64 * t
			var xOffset := 0 if Math.isEven(i) else -32
			
			var newBrick = BRICK.instance()
			newBrick.floorY = y
			
			add_child(newBrick)
			newBrick.global_position.x = x + xOffset
			
			yield(get_tree().create_timer(delay), "timeout")
			
		y -= 32
	
func _sendBricksOffscreen():
	randomize()
	
	var children := get_children()
	children.shuffle()
	
	for c in children:
		c.floorY = 416
		
		yield(get_tree().create_timer(delay), "timeout")
