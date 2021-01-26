extends Node2D

onready var tilemap = get_node("../../Navigation2D/TileMap")
onready var pos = Vector2(int(position.x/32), int(position.y/32))

func _ready():
	tilemap.set_cell(pos.x, pos.y, 5)

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		tilemap.set_cell(pos.x, pos.y, 4)


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		if 1 >= len($Area2D.get_overlapping_bodies()):
			tilemap.set_cell(pos.x, pos.y, 5)
	else:
		tilemap.set_cell(pos.x, pos.y, 5)
