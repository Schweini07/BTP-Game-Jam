extends Node2D

signal state_changed(new_state)

enum State {
	DISABLED,
	SEARCH,
	ATTACK,
}

var is_initialized := false
var current_state: int = State.DISABLED setget set_state

var _enemy: BaseEnemy = null
var _player: Player = null
var _nav_2d: Navigation2D = null

onready var player_detection_area: Area2D = $PlayerDetectionArea


func _physics_process(_delta: float) -> void:
	if not is_initialized:
		return
	
	match current_state:
		State.DISABLED:
			return
		State.SEARCH:
			pass
		State.ATTACK:
			if not _player:
				print_debug("No player found in attack state")
				return

			if not _nav_2d:
				print_debug("No nav 2d found in attack state")
				return

			var path_to_player := _nav_2d.get_simple_path(
				_enemy.global_position,
				_player.follow_position_2d.global_position,
				false
			)
			_enemy.path = path_to_player
		_:
			print_debug("Enemy state not found")


func initialize(enemy: BaseEnemy, nav_2d: Navigation2D) -> void:
	is_initialized = true
	_enemy = enemy
	_nav_2d = nav_2d


func _on_PlayerDetectionArea_body_entered(body: Node) -> void:
	if body.is_in_group("player") and is_initialized:
		_player = body
		self.current_state = State.ATTACK


func set_state(new_state: int):
	if new_state == current_state:
		return

	current_state = new_state
	emit_signal("state_changed", current_state)
