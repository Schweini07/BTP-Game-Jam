extends Node2D

onready var player = get_node("../../Player")
onready var tilemap = get_node("../../Navigation2D/TileMap")
onready var pos = Vector2(int(position.x/32), int(position.y/32))
var def_overlap

func _ready():
	tilemap.set_cell(pos.x, pos.y, 5)
	def_overlap = len($Area2D.get_overlapping_bodies())

func _on_Area2D_body_entered(body):
	if body == player:
		tilemap.set_cell(pos.x, pos.y, 4)


func _on_Area2D_body_exited(body):
	print(len($Area2D.get_overlapping_bodies()))
	if body == player:
		if 1 >= len($Area2D.get_overlapping_bodies()):
			tilemap.set_cell(pos.x, pos.y, 5)
	else:
		tilemap.set_cell(pos.x, pos.y, 5)
