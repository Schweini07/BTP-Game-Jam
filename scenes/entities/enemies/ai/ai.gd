extends Node2D

var is_initialized := false

var _enemy: BaseEnemy = null
var _player: Player = null
var _nav_2d: Navigation2D = null
var _nearby_enemies: Array
var _path_to_player: PoolVector2Array

onready var player_detection_area: Area2D = $PlayerDetectionArea
onready var enemy_detection_area: Area2D = $EnemyDetectionArea
onready var calculate_path_timer: Timer = $CalculatePathTimer

onready var state = {
	DISABLED = $StateDisabled,
	ATTACK = $StateAttack,
}
onready var current_state: AIState = state.DISABLED setget set_state


func set_state(new_state: AIState):
	if new_state == current_state or _enemy.idle:
		return
	current_state.pre_stop()
	current_state = new_state
	new_state.initialize(self, _enemy, _player, _nav_2d)


func initialize(enemy: BaseEnemy, player: Player, nav_2d: Navigation2D) -> void:
	is_initialized = true
	_enemy = enemy
	_player = player
	_nav_2d = nav_2d


func execute(delta: float) -> void:
	if current_state:
		current_state.execute(delta, _path_to_player, _nearby_enemies)
	else:
		push_error("Tried to execute current state but found null")


func _on_PlayerDetectionArea_body_entered(body: Node) -> void:
	if body.is_in_group("player") and is_initialized:
		self.current_state = state.ATTACK


func _on_EnemyDetectionArea_body_entered(body):
	if body == _enemy:
		return
	_nearby_enemies.append(body)


func _on_EnemyDetectionArea_body_exited(body):
	if body == _enemy:
		return
	_nearby_enemies.erase(body)


func _on_CalculatePathTimer_timeout():
	_path_to_player = _nav_2d.get_simple_path(
		_enemy.global_position, _player.follow_position.global_position, false
	)
	
	if OS.is_debug_build():
		_enemy.path_line.points = _path_to_player


func _on_Hitbox_hitbox_activated(_damage):
	self.current_state = state.ATTACK
