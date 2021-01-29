extends Node2D

onready var tilemap = get_node("../../Navigation2D/TileMap")
onready var pos = Vector2(int(position.x/32), int(position.y/32))
onready var area = $Area2D
onready var area_collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
onready var open_sfx: AudioStreamPlayer2D = $OpenSFX
onready var close_sfx: AudioStreamPlayer2D = $CloseSFX

func _ready():
	tilemap.set_cell(pos.x, pos.y, 5)

func _on_Area2D_body_entered(body):
	open_sfx.pitch_scale = rand_range(0.9, 1.1)
	open_sfx.play()
	tilemap.set_cell(pos.x, pos.y, 4)


func _on_Area2D_body_exited(body):
	if len(area.get_overlapping_bodies()) > 1:
		return
	
	close_sfx.pitch_scale = rand_range(0.9, 1.1)
	close_sfx.play()
	tilemap.set_cell(pos.x, pos.y, 5)
