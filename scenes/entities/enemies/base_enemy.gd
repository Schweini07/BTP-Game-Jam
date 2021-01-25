extends "res://scenes/entities/base_entity/base_entity.gd"

const SPEED := 200

var path: PoolVector2Array setget set_path
var should_move_along_path := false

onready var anim_sprite: AnimatedSprite = $AnimatedSprite


func _pre_apply_movement(delta: float) -> void:
	if not should_move_along_path:
		return

	_move_along_path()

	if position.distance_to(path[0]) <= SPEED * delta:
		position = position.round()
		path.remove(0)
	if not path:
		_velocity = Vector2.ZERO
		should_move_along_path = false


func _post_apply_movement(_delta: float) -> void:
	animate()


func animate() -> void:
	print(anim_sprite.animation, anim_sprite.frame)
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
	var next_point := path[0]
	var dir = position.direction_to(next_point)
	_velocity = dir * SPEED
