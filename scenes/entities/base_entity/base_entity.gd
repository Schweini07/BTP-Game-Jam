class_name BaseEntity
extends KinematicBody2D

var velocity := Vector2.ZERO


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
