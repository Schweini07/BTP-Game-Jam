extends Node2D

var wh
var box_chance = 6
var boxes = [load("res://scenes/dungeon/room/boxes/box.tscn")]
var boss_multiplicator = 1

onready var enemies = $enemies

func _ready():
	if wh.x > 6 and wh.y > 6:
		add_boxes()
	if position.x > 224 or position.y > 224:
		add_enemies()

func add_enemies():
	var enemy_num = (randi()%2+1) * boss_multiplicator * ((wh.x * wh.y)/75) + 1
	var inst
	for _i in range(enemy_num):
		inst = load("res://scenes/entities/enemies/base_enemy.tscn").instance()
		inst.position = Vector2(
			randi()%int(wh.x-2)*32+48,
			randi()%int(wh.y-2)*32+48
		)
		while get_node("/root/Main/Navigation2D/TileMap").get_cell((position.x + inst.position.x)/32, (position.y + inst.position.y)/32) != 0:
			inst.position = Vector2(
				randi()%int(wh.x-2)*32+48,
				randi()%int(wh.y-2)*32+48
			)
		inst.nav_2d_path = "/root/Main/Navigation2D"
		inst.player_path = "/root/Main/Player"
		enemies.add_child(inst)

func add_boxes():
	var box_num = wh.x * wh.y * (0.01 * box_chance)
	var offset
	for _i in range(box_num):
		offset = Vector2(randi()%int(wh.x-4)+2, randi()%int(wh.y-4)+2)
		get_node("../../../Navigation2D/TileMap").set_cell(position.x/32+offset.x,  position.y/32+offset.y, 2)
