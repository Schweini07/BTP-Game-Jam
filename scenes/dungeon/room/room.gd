extends Node2D

var wh
var box_chance = 6
var boxes = [load("res://scenes/dungeon/room/boxes/box.tscn")]

func _ready():
	print(global_position)
#	pass
	add_boxes()

func add_boxes():
	var box_num = wh.x*wh.y*(0.01*box_chance)
	for i in range(box_num):
		var inst = boxes[randi()%len(boxes)].instance()
		inst.position = (Vector2(randi()%int(wh.x-2), randi()%int(wh.y-2))) * 64 + Vector2(72,72)
		add_child(inst)
