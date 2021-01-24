extends Node2D

onready var nav_2d: Navigation2D = $Navigation2D
onready var line_2d: Line2D = $Line2D
onready var enemy: KinematicBody2D = $Enemy
onready var player: KinematicBody2D = $Player


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton or event.button_index != BUTTON_LEFT or not event.pressed:
		return

	var new_path := nav_2d.get_simple_path(enemy.global_position, player.global_position, false)
	line_2d.points = new_path
	new_path.remove(0)
	enemy.path = new_path
