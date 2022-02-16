extends Sprite

func destroy():
	var rotations := [0, 45, 90, 135, 180, 225, 270, 315]
	
	for i in range(rotations.size()):
		var dust = load("res://Data/Particles/FastDust.tscn").instance()
	
		get_parent().add_child(dust)
		dust.global_position = global_position
		dust.gravity = 4
		dust.velocity = Vector2(0, -75).rotated(deg2rad(rotations[i]))
		
	queue_free()
