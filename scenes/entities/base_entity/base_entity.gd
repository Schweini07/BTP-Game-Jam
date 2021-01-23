extends KinematicBody2D

var _velocity := Vector2.ZERO
var _health: float = 100


func _physics_process(delta: float) -> void:
	_pre_apply_movement(delta)
	_apply_movement()


func _pre_apply_movement(_delta: float) -> void:
	pass


func _apply_movement() -> void:
	_velocity = move_and_slide(_velocity)


func hurt(damage: float) -> void:
	_health -= damage
	if _health <= 0:
		die()


func die() -> void:
	pass
