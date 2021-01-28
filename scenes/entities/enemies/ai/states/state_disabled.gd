extends AIState


func post_initialize() -> void:
	enemy.remove_from_group("enemies_attacking")


func execute(_delta: float, _path_to_player: PoolVector2Array, _nearby_enemies: Array) -> void:
	return
