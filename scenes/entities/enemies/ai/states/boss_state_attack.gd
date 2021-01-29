extends AIState

const SPEED = 230
const REACHED_PLAYER_MIN_DIST := 10

var path_to_player_original: PoolVector2Array
var path_to_player_current: PoolVector2Array


func post_initialize() -> void:
	ai.calculate_path_timer.start()
	ai.summon_minions()


func pre_stop() -> void:
	ai.calculate_path_timer.stop()


func execute(delta: float, path: PoolVector2Array, _nearby_enemies: Array) -> void:
	if not path:
		enemy.velocity = Vector2.ZERO
		return
	
	if path_to_player_original == path:
		return
	path_to_player_original = path
	path_to_player_current = path
	
	if enemy.global_position.distance_to(player.follow_position.global_position) <= REACHED_PLAYER_MIN_DIST:
		enemy.velocity = Vector2.ZERO
		return
	
	var dir := get_follow_path_dir(delta, path_to_player_current, enemy)
	
	enemy.velocity = dir * SPEED


func get_follow_path_dir(delta: float, path: PoolVector2Array, enemy: BaseEnemy) -> Vector2:
	var dir := enemy.global_position.direction_to(path[1])
	if enemy.global_position.distance_to(path[1]) <= SPEED * delta:
		path.remove(0)
		path_to_player_current = path
	if path.size() <= 1:
		enemy.velocity = Vector2.ZERO
		path_to_player_current = PoolVector2Array()
	return dir
