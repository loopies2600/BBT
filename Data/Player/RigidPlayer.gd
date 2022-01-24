extends RigidBody2D

export (float, 0, 1) var damping = 0.86
export (float) var maxSpd = 140
export (float) var jumpHeight = 512
export (float) var gravity = 25
export (Vector2) var upDirection = Vector2.UP
export (float, 0, 1) var floorTreshold = 0.6 

var canInput = true
var floorIdx := -1

func _integrate_forces(state):
	if getInputDirection():
		state.linear_velocity.x = maxSpd * getInputDirection()
	else:
		if isOnFloor(state):
			state.linear_velocity.x *= damping
	
	if isOnFloor(state):
		if Input.is_action_just_pressed("jump"):
			state.linear_velocity.y = -jumpHeight
	else:
		state.linear_velocity += state.get_total_gravity()
	
	if isOnCeiling(state):
		state.linear_velocity.y = jumpHeight / 4
		
func isOnFloor(state : Physics2DDirectBodyStateSW) -> bool:
	for i in range(state.get_contact_count()):
		var normal := state.get_contact_local_normal(i)
		
		if normal.dot(upDirection) > floorTreshold:
			floorIdx = i
			return true
		
	floorIdx = -1
	return false
	
func isOnCeiling(state : Physics2DDirectBodyStateSW) -> bool:
	for i in range(state.get_contact_count()):
		var normal := state.get_contact_local_normal(i)
		
		if normal.dot(-upDirection) > floorTreshold:
			return true
		
	return false
	
func getInputDirection() -> int:
	if !canInput: return 0
	
	return int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	
