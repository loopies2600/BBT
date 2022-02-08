extends Node

func getInputDirection() -> int:
	if !get_parent().canInput: return 0
	
	return int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	
func triggerTimed(variable : String, time := 1.0, endBool := false):
	get_parent().set(variable, !endBool)
	yield(get_tree().create_timer(time), "timeout")
	get_parent().set(variable, endBool)
	
func findNearObjects(groups := ["Holdable"]):
	var closeObjs := []
	
	for g in groups:
		for n in get_tree().get_nodes_in_group(g):
			var distance = n.global_position.distance_to(get_parent().global_position)
			
			if distance < get_parent().objDetectionRadius:
				closeObjs.append(n)
			
	closeObjs.sort_custom(self, "sortByClosest")
	
	return closeObjs[0] if closeObjs.size() != 0 else null

func sortByClosest(a, b) -> bool:
	if a.global_position.distance_to(get_parent().global_position) < b.global_position.distance_to(get_parent().global_position):
		return true
	else: return false
