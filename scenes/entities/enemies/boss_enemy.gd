extends BaseEnemy

onready var health_bar: TextureProgress = $HealthBar


func _pre_ready() -> void:
	ai = $BossAI


func _ready():
	health_bar.max_value = health
	health_bar.value = health


func _post_hurt(_damage: float, _is_dead: bool) -> void:
	health_bar.value = health
	
	if _is_dead:
		Global.camera.shake(camera_shake_death_dur, camera_shake_death_freq, camera_shake_death_amp)
		
		var particles = DEATH_PARTICLES_SCENE.instance()
		particles.global_position = global_position
		get_tree().root.add_child(particles)
		particles.start()
	else:
		Global.camera.shake(camera_shake_hit_dur, camera_shake_hit_freq, camera_shake_hit_amp)
		
		anim_player.play("hurt")
