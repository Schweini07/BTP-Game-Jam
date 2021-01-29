extends BaseEnemy

onready var health_bar: TextureProgress = $HealthBar


func _pre_ready() -> void:
	ai = $BossAI


func _ready():
	health_bar.max_value = health
	health_bar.value = health


func _post_hurt(_damage: float, _is_dead: bool, is_burn_damage: bool) -> void:
	health_bar.value = health
	
	if _is_dead: # TODO: Boss Death SFX
		Global.emit_signal("boss_killed")
		Global.camera.shake(camera_shake_death_dur, camera_shake_death_freq, camera_shake_death_amp)
		spawn_death_particles()
		for enemy in get_tree().get_nodes_in_group("minions"):
			enemy.die()
			enemy.spawn_death_particles()
	else:
		Global.camera.shake(camera_shake_hit_dur, camera_shake_hit_freq, camera_shake_hit_amp)
		hurt_sfx.play()
		if is_burn_damage:
			anim_player.play("hurt_burn")
		else:
			anim_player.play("hurt")
