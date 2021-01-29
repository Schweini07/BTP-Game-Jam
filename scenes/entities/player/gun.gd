extends Sprite

var positions = [Vector2(2, 7.6), Vector2(-2, 7.6)]

func _process(_delta):
	if abs(int(rotation_degrees)%360) > 90 and abs(int(rotation_degrees)%360) < 270:
		flip_v = true
		position = positions[1]
	else:
		flip_v = false
		position = positions[0]
