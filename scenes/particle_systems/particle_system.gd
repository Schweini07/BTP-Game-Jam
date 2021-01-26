class_name ParticleSystem
extends CPUParticles2D


func _ready():
	set_process(false)


func _process(_delta: float):
	if not emitting:
		set_process(false)
		yield(get_tree().create_timer(lifetime), "timeout")
		queue_free()


func start() -> void:
	emitting = true
	set_process(true)
