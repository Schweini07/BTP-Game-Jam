extends Node2D

const ENEMY_SCENE := preload("res://scenes/entities/enemies/base_enemy.tscn")

const MAX_NUM_MINIONS := 4

var is_initialized := false

var _enemy: BaseEnemy = null
var _player: Player = null
var _nav_2d: Navigation2D = null
var _path_to_player: PoolVector2Array

onready var player_detection_area: Area2D = $PlayerDetectionArea
onready var calculate_path_timer: Timer = $CalculatePathTimer

onready var state = {
	DISABLED = $StateDisabled,
	ATTACK = $StateAttack,
}
onready var current_state: AIState = state.DISABLED setget set_state


func set_state(new_state: AIState):
	if new_state == current_state or not _enemy:
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
		current_state.execute(delta, _path_to_player, PoolVector2Array())
	else:
		push_error("Tried to execute current state but found null")


func _on_PlayerDetectionArea_body_entered(body: Node) -> void:
	if body.is_in_group("player") and is_initialized:
		self.current_state = state.ATTACK


func _on_CalculatePathTimer_timeout():
	_path_to_player = _nav_2d.get_simple_path(
		_enemy.global_position, _player.follow_position.global_position, false
	)
	
	if OS.is_debug_build():
		_enemy.path_line.points = _path_to_player


func _on_Hitbox_hitbox_activated(_damage, _is_burn_damage):
	self.current_state = state.ATTACK


func _on_SummonEnemyTimer_timeout():
	if current_state != state.ATTACK:
		return
	
	summon_minions()


func summon_minions() -> void:
	var num_minions := len(get_tree().get_nodes_in_group("minions"))
	var num_to_add = MAX_NUM_MINIONS - num_minions
	for i in num_to_add:
		var enemy := ENEMY_SCENE.instance()
		enemy.add_to_group("minions")
		enemy.global_position = global_position
		enemy.nav_2d_path = _nav_2d.get_path()
		enemy.player_path = _player.get_path()
		$"/root/Main".call_deferred("add_child", enemy)
		yield(enemy, "ready")
		enemy.ai.state.ATTACK.speed = rand_range(280, 340)
		enemy.ai.current_state = enemy.ai.state.ATTACK
