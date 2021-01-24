extends "res://scenes/entities/base_entity/base_entity.gd"

const SPEED := 300

var path: PoolVector2Array setget set_path

var _start_point := Vector2.ZERO


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	_move_along_path()
	
	if position.distance_to(path[0]) <= SPEED * delta:
		_velocity = Vector2.ZERO
		position = path[0]
		path.remove(0)
		_start_point = position
	if not path:
		set_physics_process(false)


func set_path(value: PoolVector2Array) -> void:
	path = value
	if not value:
		return
	set_physics_process(true)
	_start_point = position


func _move_along_path() -> void:
	var next_point := path[0]
	var dir = position.direction_to(next_point)
	_velocity = dir * SPEED
