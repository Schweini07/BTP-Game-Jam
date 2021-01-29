class_name Player
extends BaseEntity

signal hurt

var MAX_SPEED := 240
var ACC := 4000
const DEACC := 2000

const CAMERA_SHAKE_HIT_DUR := 0.4
const CAMERA_SHAKE_HIT_FREQ := 30.0
const CAMERA_SHAKE_HIT_AMP := 20.0

const DEBUG_HURT_DAMAGE := 5
const DEBUG_SHAKE_DUR := 0.2
const DEBUG_SHAKE_FREQ := 15.0
const DEBUG_SHAKE_AMP := 8.0

var was_hurt := false

var is_dashing := false # Currently not necessary but may be used in the future
var can_dash := true
var immune := false

onready var camera: Camera2D = $Camera2D
onready var anim_sprite: AnimatedSprite = $AnimatedSprite
onready var gun: Sprite = $Gun
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var follow_position: Position2D = $FollowPosition
onready var invincibility_timer: Timer = $InvincibilityTimer
onready var hitbox_collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D
onready var dash_duration_timer: Timer = $DashDurationTimer
onready var dash_cooldown_timer: Timer = $DashCooldownTimer
onready var gun_shot_sfx: AudioStreamPlayer2D = $GunShotSFX
onready var player_hurt_sfx: AudioStreamPlayer2D = $PlayerHurtSFX
onready var health_refill_sfx: AudioStreamPlayer2D = $HealthRefillSFX
onready var reload_sfx: AudioStreamPlayer2D = $ReloadSFX

var run_anim
var idle_anim
var hurt_anim

func _ready():
	update_animations()
	Global.camera = camera

	if Global.has_speed_upgrade:
		MAX_SPEED = 480


func _process(_delta: float) -> void:
	gun.look_at(get_global_mouse_position())


func _unhandled_input(event):
	if not OS.is_debug_build():
		return
	if event.is_action_pressed("debug_hurt_player"):
		hurt(DEBUG_HURT_DAMAGE)
	if event.is_action_pressed("debug_shake_camera"):
		camera.shake(DEBUG_SHAKE_DUR, DEBUG_SHAKE_FREQ, DEBUG_SHAKE_AMP)


func _pre_apply_movement(delta: float) -> void:
	var input := _get_input_vector()
	if (Global.has_dash and can_dash and not is_dashing and
			Input.is_action_just_pressed("dash")):
		is_dashing = true
		MAX_SPEED *= 3
		ACC *= 2
		dash_duration_timer.start()
		get_parent().hud.start_dash_cooldown()
		
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
			anim_sprite.play(run_anim)
	elif not was_hurt:
		anim_sprite.play(idle_anim)


func _get_input_vector() -> Vector2:
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
	if is_dashing or immune:
		return
	
	Global.health -= damage
	var is_dead = false
	if Global.health <= 0:
		is_dead = true
		die()
	emit_signal("hurt")
	_post_hurt(damage, is_dead)


func _post_hurt(_damage: float, _is_dead: bool) -> void:
	was_hurt = true
	hitbox_collision_shape.set_deferred("disabled", true)
	immune = true
	invincibility_timer.start()
	Global.camera.shake(CAMERA_SHAKE_HIT_DUR, CAMERA_SHAKE_HIT_FREQ, CAMERA_SHAKE_HIT_AMP)
	if _is_dead: # TODO: Player death SFX
		pass
	else:
		player_hurt_sfx.pitch_scale = rand_range(0.9, 1.1)
		player_hurt_sfx.play()
	anim_sprite.play(hurt_anim)
	anim_player.play("hurt")
	yield(anim_sprite, "animation_finished")
	was_hurt = false


func update_animations() -> void:
	var anim_map = {
		false: ["run", "idle", "hurt"],
		true: ["run_hat", "idle_hat", "hurt_hat"],
	}
	
	run_anim = anim_map[Global.has_hat][0]
	idle_anim = anim_map[Global.has_hat][1]
	hurt_anim = anim_map[Global.has_hat][2]

func die() -> void:
	if get_tree().change_scene("res://scenes/ui/game_over/game_over.tscn") != OK:
		push_error("Error found while trying to change to the game over scene")


func _on_InvincibilityTimer_timeout():
	hitbox_collision_shape.set_deferred("disabled", false)
	immune = false


func _on_DashDurationTimer_timeout():
	MAX_SPEED /= 3
	ACC /= 2
	can_dash = false
	is_dashing = false
	dash_cooldown_timer.start()


func _on_DashCooldownTimer_timeout():
	can_dash = true
