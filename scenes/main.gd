extends Node2D

var bullet: PackedScene = preload("res://scenes/player/bullet.tscn")

onready var shoot_pos: Position2D = $Player/Gun/ShootPos
onready var gun: Sprite = $Player/Gun


func shoot() -> void:
	var bullet_instance: Area2D = bullet.instance()
	bullet_instance.position = shoot_pos.global_position
	bullet_instance.rotation_degrees = gun.rotation_degrees
	bullet_instance.vector = Vector2(1, 0).rotated(gun.rotation)
	add_child(bullet_instance)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		shoot()
