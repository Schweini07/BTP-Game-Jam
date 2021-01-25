extends Node2D

var bullet: PackedScene = preload("res://scenes/entities/player/bullet.tscn")

onready var nav_2d: Navigation2D = $Navigation2D
onready var line_2d: Line2D = $Line2D
onready var enemy: KinematicBody2D = $BaseEnemy
onready var player: KinematicBody2D = $Player
onready var shoot_pos: Position2D = $Player/Gun/ShootPos
onready var gun: Sprite = $Player/Gun


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		shoot()

	if not event is InputEventMouseButton or event.button_index != BUTTON_LEFT or not event.pressed:
		return

	var new_path := nav_2d.get_simple_path(enemy.global_position, player.global_position, false)
	line_2d.points = new_path
	new_path.remove(0)
	enemy.path = new_path


func shoot() -> void:
	var bullet_instance: Area2D = bullet.instance()
	bullet_instance.position = shoot_pos.global_position
	bullet_instance.rotation_degrees = gun.rotation_degrees
	bullet_instance.vector = Vector2(1, 0).rotated(gun.rotation)
	add_child(bullet_instance)
