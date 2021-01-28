extends Node2D

var bullet: PackedScene = preload("res://scenes/entities/player/bullet.tscn")
var ammo := 24
var can_shoot: bool = true
var reloading: bool = false

onready var player: KinematicBody2D = $Player
onready var shoot_pos: Position2D = $Player/Gun/ShootPos
onready var gun: Sprite = $Player/Gun
onready var shoot_cooldown: Timer = $ShootCooldown

func _process(delta) -> void:
	if Input.is_action_pressed("fire"):
		if can_shoot and !reloading:
			shoot()
	if Input.is_action_pressed("RMB"):
		if can_shoot and !reloading:
			Global.can_shoot_ib = true
			shoot()


func shoot() -> void:
	var bullet_instance: Area2D = bullet.instance()
	bullet_instance.position = shoot_pos.global_position
	bullet_instance.rotation_degrees = gun.rotation_degrees
	bullet_instance.vector = Vector2(1, 0).rotated(gun.rotation)
	
	add_child(bullet_instance)
	
	shoot_cooldown.start()
	can_shoot = false
	
	if Global.has_no_reload:
		return
	
	if ammo == 0:
		reloading = true
		yield(get_tree().create_timer(1), "timeout")
		reloading = false
		ammo = 24
	else:
		ammo -= 1


func _on_ShootCooldown_timeout() -> void:
	can_shoot = true
