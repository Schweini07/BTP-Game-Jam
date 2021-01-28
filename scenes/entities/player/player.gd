class_name Player
extends BaseEntity

var MAX_SPEED := 240
const ACC := 4000
const DEACC := 2000

const CAMERA_SHAKE_HIT_DUR := 0.4
const CAMERA_SHAKE_HIT_FREQ := 30.0
const CAMERA_SHAKE_HIT_AMP := 20.0

const DEBUG_HURT_DAMAGE := 5
const DEBUG_SHAKE_DUR := 0.2
const DEBUG_SHAKE_FREQ := 15.0
const DEBUG_SHAKE_AMP := 8.0

var was_hurt := false

onready var debug_canvas: CanvasLayer = $Debug
onready var camera: Camera2D = $Camera2D
onready var anim_sprite: AnimatedSprite = $AnimatedSprite
onready var gun: Sprite = $Gun
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var follow_position: Position2D = $FollowPosition
onready var invincibility_timer: Timer = $InvincibilityTimer
onready var hitbox_collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D


func _ready():
	Global.camera = camera

	if Global.has_speed_upgrade:
		MAX_SPEED = 480


func _process(_delta: float) -> void:
	if OS.is_debug_build():
		debug_canvas.label_velocity.text = "Velocity: (%.1f, %.1f)" % [velocity.x, velocity.y]
		debug_canvas.label_speed.text = "Speed: %.1f" % velocity.length()
		debug_canvas.label_health.text = "Health: %.1f" % Global.health

	gun.look_at(get_global_mouse_position())


func _unhandled_input(event):
	if not OS.is_debug_build():
		return
	if event.is_action_pressed("debug_hurt_player"):
		hurt(DEBUG_HURT_DAMAGE)
	if event.is_action_pressed("debug_shake_camera"):
		camera.shake(DEBUG_SHAKE_DUR, DEBUG_SHAKE_FREQ, DEBUG_SHAKE_AMP)


func _pre_apply_movement(delta: float) -> void:
	var input := _get_input()
	if input == Vector2.ZERO:
		_apply_friction(DEACC * delta)
	else:
		_accelerate(input.normalized() * ACC * delta)


func _post_apply_movement(_delta: float) -> void:
	animate()


func animate() -> void:
	if velocity.length() > 0:
		anim_sprite.flip_h = velocity.x < 0
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
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO


func _accelerate(amount: Vector2) -> void:
	velocity += amount
	if velocity.length() > MAX_SPEED:
		velocity = velocity.clamped(MAX_SPEED)


func hurt(damage: int) -> void:
	Global.health -= damage
	var is_dead = false
	if Global.health <= 0:
		is_dead = true
		die()
	_post_hurt(damage, is_dead)


func _post_hurt(_damage: float, _is_dead: bool) -> void:
	was_hurt = true
	hitbox_collision_shape.set_deferred("disabled", true)
	invincibility_timer.start()
	Global.camera.shake(CAMERA_SHAKE_HIT_DUR, CAMERA_SHAKE_HIT_FREQ, CAMERA_SHAKE_HIT_AMP)
	anim_sprite.play("hurt")
	anim_player.play("hurt")
	yield(anim_sprite, "animation_finished")
	was_hurt = false


func die() -> void:
	if get_tree().change_scene("res://scenes/ui/game_over/game_over.tscn") != OK:
		push_error("Error found while trying to change to the game over scene")


func _on_InvincibilityTimer_timeout():
	hitbox_collision_shape.set_deferred("disabled", false)
