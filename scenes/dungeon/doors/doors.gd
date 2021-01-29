extends Node2D

export (bool) var inactive

onready var tilemap = get_node("../../Navigation2D/TileMap")
onready var pos = Vector2(int(position.x/32), int(position.y/32))
onready var area = $Area2D
onready var area_collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
onready var toggle_sfx: AudioStreamPlayer2D = $ToggleSFX

func _ready():
	tilemap.set_cell(pos.x, pos.y, 5)

func _on_Area2D_body_entered(body):
	if inactive:
		return
	
	if body.is_in_group("player"):
		toggle_sfx.pitch_scale = rand_range(0.9, 1.1)
		toggle_sfx.play()
	tilemap.set_cell(pos.x, pos.y, 4)


func _on_Area2D_body_exited(body):
	if len(area.get_overlapping_bodies()) > 1 or inactive:
		return
	
	if body.is_in_group("player"):
		toggle_sfx.pitch_scale = rand_range(0.9, 1.1)
		toggle_sfx.play()
	tilemap.set_cell(pos.x, pos.y, 5)
