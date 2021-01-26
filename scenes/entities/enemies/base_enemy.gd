class_name BaseEnemy
extends "res://scenes/entities/base_entity/base_entity.gd"

const DEATH_PARTICLES_SCENE = preload("res://scenes/particle_systems/entities/enemies/enemy_death_particles.tscn")
const SPEED := 200

const CAMERA_SHAKE_DEATH_DUR := 0.4
const CAMERA_SHAKE_DEATH_FREQ := 30.0
const CAMERA_SHAKE_DEATH_AMP := 12.0
const CAMERA_SHAKE_HIT_DUR := 0.2
const CAMERA_SHAKE_HIT_FREQ := 10.0
const CAMERA_SHAKE_HIT_AMP := 4.0

export (NodePath) var nav_2d_path

var path: PoolVector2Array setget set_path
var should_move_along_path := false

onready var ai: Node2D = $AI
onready var anim_sprite: AnimatedSprite = $AnimatedSprite
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var collision_shape: CollisionShape2D = $CollisionShape2D
onready var hitbox_collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D
onready var path_line: Line2D = $PathNode/Path


func _ready() -> void:
	if not nav_2d_path:
		print_debug("Tried to initialize AI but no nav_2d_path was found")
		return
	
	var nav_2d_node: Node = get_node(nav_2d_path)
	if not nav_2d_node or not nav_2d_node as Navigation2D:
		print_debug("Tried to initialize AI but no Navigation2D node was found at the path specified")
		return

	ai.initialize(self, nav_2d_node)


func _pre_apply_movement(delta: float) -> void:
	if not should_move_along_path:
		return

	_move_along_path()

	if position.distance_to(path[1]) <= SPEED * delta:
		position = position.round()
		path.remove(0)
	if path.size() <= 1:
		_velocity = Vector2.ZERO
		should_move_along_path = false


func _post_apply_movement(_delta: float) -> void:
	animate()


func animate() -> void:
	if _velocity.length() > 0:
		anim_sprite.flip_h = _velocity.x < 0
		anim_sprite.play("run")
	else:
		anim_sprite.play("idle")


func set_path(value: PoolVector2Array) -> void:
	path = value
	if not value:
		return
	should_move_along_path = true


func _move_along_path() -> void:
	var next_point := path[1]
	var dir = position.direction_to(next_point)
	_velocity = dir * SPEED


func _post_hurt(_damage: float, _is_dead: bool) -> void:
	if _is_dead:
		Global.camera.shake(CAMERA_SHAKE_DEATH_DUR, CAMERA_SHAKE_DEATH_FREQ, CAMERA_SHAKE_DEATH_AMP)
		
		var particles = DEATH_PARTICLES_SCENE.instance()
		particles.global_position = global_position
		get_tree().root.add_child(particles)
		particles.start()
	else:
		Global.camera.shake(CAMERA_SHAKE_HIT_DUR, CAMERA_SHAKE_HIT_FREQ, CAMERA_SHAKE_HIT_AMP)
		
		anim_player.play("hurt")
