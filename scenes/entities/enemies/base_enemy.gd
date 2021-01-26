class_name BaseEnemy
extends BaseEntity

const DEATH_PARTICLES_SCENE = preload("res://scenes/particle_systems/entities/enemies/enemy_death_particles.tscn")

const CAMERA_SHAKE_DEATH_DUR := 0.4
const CAMERA_SHAKE_DEATH_FREQ := 30.0
const CAMERA_SHAKE_DEATH_AMP := 12.0
const CAMERA_SHAKE_HIT_DUR := 0.2
const CAMERA_SHAKE_HIT_FREQ := 10.0
const CAMERA_SHAKE_HIT_AMP := 4.0

export (NodePath) var nav_2d_path
export (NodePath) var player_path

onready var ai: Node2D = $AI
onready var anim_sprite: AnimatedSprite = $AnimatedSprite
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var collision_shape: CollisionShape2D = $CollisionShape2D
onready var hitbox_collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D
onready var path_line: Line2D = $PathNode/Path


func _ready() -> void:
	anim_sprite.material = anim_sprite.material.duplicate()
	
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


func _pre_apply_movement(delta: float) -> void:
	ai.execute(delta)


func _post_apply_movement(_delta: float) -> void:
	animate()


func animate() -> void:
	if velocity.length() > 0:
#		if abs(velocity.x) > 1.5:
#			print("VEL X: ", velocity.x, " ¬ ", abs(velocity.x), " ¬ ", abs(velocity.x) > 0.5)
		anim_sprite.flip_h = velocity.x < 0
		anim_sprite.play("run")
	else:
		anim_sprite.play("idle")


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
