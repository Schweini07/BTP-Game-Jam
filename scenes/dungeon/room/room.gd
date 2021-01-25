extends Node2D

var wh
var box_chance = 6
var boxes = [load("res://scenes/dungeon/room/boxes/box.tscn")]


func _ready():
	add_boxes()


func add_boxes():
	var box_num = wh.x * wh.y * (0.01 * box_chance)
	var offset
	for _i in range(box_num):
		offset = Vector2(randi()%int(wh.x-3)+2, randi()%int(wh.y-3)+2)
		get_node("../../../Navigation2D/TileMap").set_cell(position.x/32+offset.x,  position.y/32+offset.y, 2)
