class_name BaseEntity
extends KinematicBody2D

var velocity := Vector2.ZERO
var health: float = 100


func _physics_process(delta: float) -> void:
	_pre_apply_movement(delta)
	_apply_movement(delta)
	_post_apply_movement(delta)


func _pre_apply_movement(_delta: float) -> void:
	pass


func _apply_movement(_delta: float) -> void:
	velocity = move_and_slide(velocity)


func _post_apply_movement(_delta: float) -> void:
	pass


func hurt(damage: float) -> void:
	health -= damage
	var is_dead = false
	if health <= 0:
		is_dead = true
		die()
	_post_hurt(damage, is_dead)


func _post_hurt(_damage: float, _is_dead: bool) -> void:
	pass


func die() -> void:
	queue_free()
