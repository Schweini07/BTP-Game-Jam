class_name AIState
extends Node


func execute(_delta: float, _enemy: BaseEnemy, _ai: Node2D, _player: Player, _nav_2d: Navigation2D, _nearby_enemies: Array) -> void:
	push_error("Execute method called on state without first overriding it")
