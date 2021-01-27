extends Node2D

var wh
var box_chance = 6
var boxes = [load("res://scenes/dungeon/room/boxes/box.tscn")]
var boss_multiplicator = 1

func _ready():
	add_boxes()
	add_enemies()

func add_enemies():
	var enemy_num = (randi()%4+1) * boss_multiplicator 
	var inst
	for _i in range(enemy_num):
		inst = load("res://scenes/entities/enemies/base_enemy.tscn").instance()
		inst.position = Vector2(
			randi()%int(wh.x-2)*32+48,
			randi()%int(wh.y-2)*32+48
		)
		$enemies.add_child(inst)

func add_boxes():
	var box_num = wh.x * wh.y * (0.01 * box_chance)
	var offset
	for _i in range(box_num):
		offset = Vector2(randi()%int(wh.x-3)+2, randi()%int(wh.y-3)+2)
		get_node("../../../Navigation2D/TileMap").set_cell(position.x/32+offset.x,  position.y/32+offset.y, 2)
