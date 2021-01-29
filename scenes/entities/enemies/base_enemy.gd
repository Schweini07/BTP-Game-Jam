class_name BaseEnemy
extends BaseEntity

const DEATH_PARTICLES_SCENE = preload("res://scenes/particle_systems/entities/enemies/enemy_death_particles.tscn")

export (NodePath) var nav_2d_path
export (NodePath) var player_path
export (bool) var idle
export var health := 100
export var damage := 5

export var camera_shake_death_dur := 0.4
export var camera_shake_death_freq := 30.0
export var camera_shake_death_amp := 12.0

export var camera_shake_hit_dur := 0.2
export var camera_shake_hit_freq := 10.0
export var camera_shake_hit_amp := 4.0

var ai: Node2D

# needed for immobolizing bullets
var tmp_speed : int

onready var anim_sprite: AnimatedSprite = $AnimatedSprite
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var path_line: Line2D = $PathNode/Path
onready var flaming_bullets_timer: Timer = $FlamingBulletsTimer
onready var flaming_bullets_timeout: Timer = $FlamingBulletsTimeout
onready var immobolizing_bullets_timer: Timer = $ImmobolizingBulletsTimer
onready var immobolizing_bullets_timeout: Timer = get_tree().root.get_node("Main/ImmobolizingBulletsTimeout")
onready var hurt_sfx: AudioStreamPlayer2D = $HurtSFX
onready var main: Node2D = get_tree().root.get_node("Main")


func _ready() -> void:
	_pre_ready()
	
	anim_sprite.frame = randi() % anim_sprite.frames.get_frame_count("idle")
	anim_sprite.material = anim_sprite.material.duplicate()
	
	if idle:
		return
	
	if not nav_2d_path:
		push_error("Tried to initialize AI but no nav_2d_path was found")
		return
	var nav_2d_node: Node = get_node(nav_2d_path)
	if not nav_2d_node or not nav_2d_node as Navigation2D:
		push_error("Tried to initialize AI but no Navigation2D node was found at the path specified")
		return
	
	if not player_path:
		push_error("Tried to initialize AI but no player_path was found")
		return
	var player_node: Node = get_node(player_path)
	if not player_node or not player_node as Player:
		push_error("Tried to initialize AI but no player node was found at the path specified")
		return

	ai.initialize(self, player_node, nav_2d_node)


func _pre_ready() -> void:
	ai = $AI


func _pre_apply_movement(delta: float) -> void:
	if idle:
		return
	ai.execute(delta)


func _post_apply_movement(_delta: float) -> void:
	animate()


func animate() -> void:
	if velocity.length() > 0:
		anim_sprite.flip_h = velocity.x < 0
		anim_sprite.play("run")
	else:
		anim_sprite.play("idle")


func hurt(dmg: int) -> void:
	health -= dmg

	if Global.has_flaming_bullets and flaming_bullets_timer.is_stopped():
		flaming_bullets_timer.start()
		flaming_bullets_timeout.start()

	var is_dead = false
	if health <= 0:
		is_dead = true
		die()
	_post_hurt(dmg, is_dead)


func _post_hurt(_dmg: float, _is_dead: bool) -> void:
	if _is_dead: # TODO: Enemy Death SFX
		Global.camera.shake(camera_shake_death_dur, camera_shake_death_freq, camera_shake_death_amp)
		spawn_death_particles()
	else:
		Global.camera.shake(camera_shake_hit_dur, camera_shake_hit_freq, camera_shake_hit_amp)
		hurt_sfx.pitch_scale = rand_range(0.9, 1.1)
		hurt_sfx.play()
		anim_player.play("hurt")


func spawn_death_particles() -> void:
	var particles = DEATH_PARTICLES_SCENE.instance()
	particles.global_position = global_position
	get_tree().root.add_child(particles)
	particles.start()


func die() -> void:
	Global.emit_signal("normal_enemy_killed")
	queue_free()

func stun() -> void:
	if Global.has_immobolizing_bullets and Global.ib_timed_out:
		Global.ib_timed_out = false
		tmp_speed = ai.state.ATTACK.speed
		ai.state.ATTACK.speed = 0
		immobolizing_bullets_timer.start()
		immobolizing_bullets_timeout.start()
		main.hud.start_ib_cooldown()


func _on_AttackBox_area_entered(area):
	area.get_parent().hurt(damage)


func _on_FlamingBulletsTimer_timeout():
	hurt(5)

func _on_FlamingBulletsTimeout_timeout():
	flaming_bullets_timer.stop()


func _on_ImmobolizingBulletsTimer_timeout():
	ai.state.ATTACK.speed = tmp_speed
