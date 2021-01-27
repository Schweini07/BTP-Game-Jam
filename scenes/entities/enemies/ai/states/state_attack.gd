extends AIState

const MAX_DIST_TO_PLAYER := 350.0
const MIN_SPEED := 130
const MAX_SPEED = 170
const ENEMY_AVOID_WEIGHT = 0.1

var path_to_player: PoolVector2Array
var prev_player_pos: Vector2

onready var speed = rand_range(MIN_SPEED, MAX_SPEED)


func execute(delta: float, enemy: BaseEnemy, ai: Node2D, player: Player, nav_2d: Navigation2D, nearby_enemies: Array) -> void:
	var dist_to_player = enemy.global_position.distance_to(player.global_position)
	if dist_to_player > MAX_DIST_TO_PLAYER:
		enemy.path_line.points = PoolVector2Array()
		enemy.velocity = Vector2.ZERO
		enemy.ai.current_state = enemy.ai.state.DISABLED
		return
	
	# Calculate path to player if the player has moved
	if player.follow_position.global_position != prev_player_pos:
		path_to_player = nav_2d.get_simple_path(
			enemy.global_position, player.follow_position.global_position, false
		)
	prev_player_pos = player.follow_position.global_position
	
	if OS.is_debug_build():
		enemy.path_line.points = path_to_player
	
	if enemy.global_position.distance_to(player.follow_position.global_position) <= speed * delta:
		enemy.velocity = Vector2.ZERO
		return
	
	if not path_to_player:
		enemy.velocity = Vector2.ZERO
		return
	
	var dir := get_follow_path_dir(delta, path_to_player, enemy, player)
	
	# Avoid nearby enemies
	for nearby_enemy in nearby_enemies:
		dir += nearby_enemy.global_position.direction_to(enemy.global_position) * ENEMY_AVOID_WEIGHT
	
	enemy.velocity = dir * speed


func get_follow_path_dir(delta: float, path: PoolVector2Array, enemy: BaseEnemy, player: Player) -> Vector2:
	var dir := enemy.global_position.direction_to(path[1])
	if enemy.global_position.distance_to(path[1]) <= speed * delta:
		path.remove(0)
		path_to_player = path
	if path.size() <= 1:
		enemy.velocity = Vector2.ZERO
		path_to_player = PoolVector2Array()
	return dir
