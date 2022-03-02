extends Node

var sortWho : Node2D

func getInputDirection(who) -> int:
	if !who.canInput: return 0
	
	return int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	
func triggerTimed(variable : String, time := 1.0, endBool := false):
	get_parent().set(variable, !endBool)
	yield(get_tree().create_timer(time), "timeout")
	get_parent().set(variable, endBool)
	
func findNearObjects(who : Node2D, groups := ["Holdable"], radius := 0.0):
	sortWho = who
	
	var closeObjs := []
	
	for g in groups:
		for n in get_tree().get_nodes_in_group(g):
			var distance = n.global_position.distance_to(who.global_position)
			
			if distance < radius:
				closeObjs.append(n)
			
	closeObjs.sort_custom(self, "sortByClosest")
	
	return closeObjs[0] if closeObjs.size() != 0 else null

func sortByClosest(a, b) -> bool:
	if a.global_position.distance_to(sortWho.global_position) < b.global_position.distance_to(sortWho.global_position):
		return true
	else: return false
