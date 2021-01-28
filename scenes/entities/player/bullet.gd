extends Area2D

const BULLET_DAMAGE := 10.0

var speed = 500
var vector: Vector2

var is_ib_bullet: bool = false

onready var anim: AnimationPlayer = $spr/anim
onready var coll: CollisionShape2D = $coll
onready var queue_free_timer: Timer = $QueueFreeTimer


func _ready() -> void:
	if Global.has_rapid_fire:
		speed = 1000

	if Global.has_massive_bullets:
		scale = Vector2(1, 1)

func _physics_process(delta) -> void:
	position += vector * speed * delta


func explode() -> void:
	speed = 0
	coll.call_deferred("set", "disabled", true)
	queue_free_timer.start()


func _on_SelfDestroy_timeout() -> void:
	$spr/anim.play("Explode")


func _on_Bullet_body_entered(_body: TileMap) -> void:
	explode()
	$spr/anim.play("Explode")


func _on_Bullet_area_entered(area: Area2D) -> void:
	if !Global.has_ghost_bullets:
		call_deferred("queue_free")
	area.emit_signal("hitbox_activated", BULLET_DAMAGE)
	
	if is_ib_bullet:
		area.get_parent().stun()

func _on_QueueFreeTimer_timeout():
	queue_free()
