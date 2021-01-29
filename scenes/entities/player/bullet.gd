extends Area2D

const EXPLODE_PARTICLES_SCENE = preload("res://scenes/particle_systems/entities/player/bullet_explode_particles.tscn")

const BULLET_DAMAGE := 10.0

var speed = 500
var vector: Vector2

var is_ib_bullet: bool = false

onready var coll: CollisionShape2D = $coll
onready var queue_free_timer: Timer = $QueueFreeTimer


func _ready() -> void:
	if Global.has_rapid_fire:
		speed = 1000

	if Global.has_massive_bullets:
		$spr.texture = load("res://assets/graphics/entities/player/bullet-big.png")

func _physics_process(delta) -> void:
	position += vector * speed * delta


func _on_Bullet_body_entered(body: TileMap) -> void:
	if body.get_cellv(body.world_to_map(global_position + vector * 10)) != 5:
		spawn_explode_particles()
	queue_free()


func _on_Bullet_area_entered(area: Area2D) -> void:
	if !Global.has_ghost_bullets:
		call_deferred("queue_free")
	area.emit_signal("hitbox_activated", BULLET_DAMAGE)
	
	if is_ib_bullet:
		area.get_parent().stun()

func _on_QueueFreeTimer_timeout():
	queue_free()


func spawn_explode_particles() -> void:
	var particles = EXPLODE_PARTICLES_SCENE.instance()
	particles.global_position = global_position
	get_tree().root.add_child(particles)
	particles.start()
