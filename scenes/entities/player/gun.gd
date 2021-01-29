extends Sprite

var positions = [Vector2(2, 7.6), Vector2(-2, 7.6)]

func _process(_delta):
	if abs(int(rotation_degrees)%360) > 95 and abs(int(rotation_degrees)%360) < 265:
		flip_v = true
		position = positions[1]
	if abs(int(rotation_degrees)%360) < 85 or abs(int(rotation_degrees)%360) > 275:
		flip_v = false
		position = positions[0]
