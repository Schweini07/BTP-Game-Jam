extends "res://scenes/entities/base_entity/base_entity.gd"

const MAX_SPEED := 380
const ACC := 4000
const DEACC := 2000

onready var label_velocity: Label = $TempDebug/Velocity
onready var label_speed: Label = $TempDebug/Speed

onready var gun = $Gun


func _process(_delta):
	label_velocity.text = "Velocity: %s" % Vector2(round(_velocity.x), round(_velocity.y))
	label_speed.text = "Speed: %s" % round(_velocity.length())
	
	gun.look_at(get_global_mouse_position())


func _pre_apply_movement(delta: float) -> void:
	var input := _get_input()
	if input == Vector2.ZERO:
		_apply_friction(DEACC * delta)
	else:
		_accelerate(input.normalized() * ACC * delta)


func _get_input() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)


func _apply_friction(amount: float) -> void:
	if _velocity.length() > amount:
		_velocity -= _velocity.normalized() * amount
	else:
		_velocity = Vector2.ZERO


func _accelerate(amount: Vector2) -> void:
	_velocity += amount
	if _velocity.length() > MAX_SPEED:
		_velocity = _velocity.clamped(MAX_SPEED)
