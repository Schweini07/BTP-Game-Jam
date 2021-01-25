class_name BaseEnemy
extends "res://scenes/entities/base_entity/base_entity.gd"

const SPEED := 200

export (NodePath) var nav_2d_path

var path: PoolVector2Array setget set_path
var should_move_along_path := false

onready var ai: Node2D = $AI
onready var anim_sprite: AnimatedSprite = $AnimatedSprite
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
