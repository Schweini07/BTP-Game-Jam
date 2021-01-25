extends "res://scenes/entities/base_entity/base_entity.gd"

const MAX_SPEED := 240
const ACC := 4000
const DEACC := 2000

const DEBUG_HURT_DAMAGE := 10

var was_hurt := false

onready var debug_canvas: CanvasLayer = $Debug
onready var anim_sprite: AnimatedSprite = $AnimatedSprite
onready var gun: Sprite = $Gun
onready var anim_player: AnimationPlayer = $AnimationPlayer


func _process(_delta: float) -> void:
	if OS.is_debug_build():
		debug_canvas.label_velocity.text = "Velocity: (%.1f, %.1f)" % [_velocity.x, _velocity.y]
		debug_canvas.label_speed.text = "Speed: %.1f" % _velocity.length()
		debug_canvas.label_health.text = "Health: %.1f" % health

	gun.look_at(get_global_mouse_position())


func _unhandled_input(event):
	if OS.is_debug_build() and event.is_action_pressed("debug_hurt_player"):
		hurt(DEBUG_HURT_DAMAGE)


func _pre_apply_movement(delta: float) -> void:
	var input := _get_input()
	if input == Vector2.ZERO:
		_apply_friction(DEACC * delta)
	else:
		_accelerate(input.normalized() * ACC * delta)


func _post_apply_movement(_delta: float) -> void:
	animate()


func animate() -> void:
	if _velocity.length() > 0:
		anim_sprite.flip_h = _velocity.x < 0
		if not was_hurt:
			anim_sprite.play("run")
	elif not was_hurt:
		anim_sprite.play("idle")


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


func _post_hurt(_damage: float, _is_dead: bool) -> void:
	was_hurt = true
	anim_sprite.play("hurt")
	anim_player.play("hurt")
	yield(anim_sprite, "animation_finished")
	was_hurt = false
