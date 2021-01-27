extends AIState

const MAX_DIST_TO_PLAYER := 350.0
const SPEED := 150.0

var path_to_player: PoolVector2Array
var prev_player_pos: Vector2


func execute(delta: float, enemy: BaseEnemy, ai: Node2D, player: Player, nav_2d: Navigation2D) -> void:
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
	
	if enemy.global_position.distance_to(player.follow_position.global_position) <= SPEED * delta * 2:
		enemy.velocity = Vector2.ZERO
		return
	
	if not path_to_player:
		enemy.velocity = Vector2.ZERO
		return
	
	follow_path(delta, path_to_player, enemy, player)


func follow_path(delta: float, path: PoolVector2Array, enemy: BaseEnemy, player: Player) -> void:
	var dir := enemy.global_position.direction_to(path[1])
	enemy.velocity = dir * SPEED
	if enemy.global_position.distance_to(path[1]) <= SPEED * delta * 2:
		path.remove(0)
		path_to_player = path
	if path.size() <= 1:
		enemy.velocity = Vector2.ZERO
		path_to_player = PoolVector2Array()
