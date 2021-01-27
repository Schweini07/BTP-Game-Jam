class_name AIState
extends Node

var ai: Node2D
var enemy: BaseEnemy
var player: Player
var nav_2d: Navigation2D


func initialize(_ai: Node2D, _enemy: BaseEnemy, _player: Player, _nav_2d: Navigation2D) -> void:
	ai = _ai
	enemy = _enemy
	player = _player
	nav_2d = _nav_2d
	post_initialize()


func post_initialize() -> void:
	pass


func pre_stop() -> void:
	pass


func execute(_delta: float, _path_to_player: PoolVector2Array, _nearby_enemies: Array) -> void:
	push_error("Execute method called on state without first overriding it")
