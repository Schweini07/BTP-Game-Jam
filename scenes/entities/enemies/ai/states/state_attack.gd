extends AIState

const MAX_DIST_TO_PLAYER := 350.0
const MIN_SPEED := 130
const MAX_SPEED = 270
const ENEMY_AVOID_WEIGHT = 0.2
const REACHED_PLAYER_MIN_DIST := 10

var path_to_player_original: PoolVector2Array
var path_to_player_current: PoolVector2Array

onready var speed = rand_range(MIN_SPEED, MAX_SPEED)


func post_initialize() -> void:
	ai.calculate_path_timer.start()


func pre_stop() -> void:
	ai.calculate_path_timer.stop()


func execute(delta: float, path: PoolVector2Array, nearby_enemies: Array) -> void:
	var dist_to_player = enemy.global_position.distance_to(player.global_position)
	if dist_to_player > MAX_DIST_TO_PLAYER:
		enemy.path_line.points = PoolVector2Array()
		enemy.velocity = Vector2.ZERO
		enemy.ai.current_state = enemy.ai.state.DISABLED
		return
	
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
	
	# Avoid nearby enemies
	for nearby_enemy in nearby_enemies:
		dir += nearby_enemy.global_position.direction_to(enemy.global_position) * ENEMY_AVOID_WEIGHT
	
	enemy.velocity = dir * speed


func get_follow_path_dir(delta: float, path: PoolVector2Array, enemy: BaseEnemy) -> Vector2:
	var dir := enemy.global_position.direction_to(path[1])
	if enemy.global_position.distance_to(path[1]) <= speed * delta:
		path.remove(0)
		path_to_player_current = path
	if path.size() <= 1:
		enemy.velocity = Vector2.ZERO
		path_to_player_current = PoolVector2Array()
	return dir
