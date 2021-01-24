extends Area2D

var speed = 1000
var vector: Vector2


func _physics_process(delta) -> void:
	position += vector * speed * delta


func _on_SelfDestroy_timeout():
	call_deferred("queue_free")


func _on_Bullet_body_entered(body):
	pass  # Replace with function body.
