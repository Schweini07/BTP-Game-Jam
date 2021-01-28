extends Node2D

const SPEED = 600

var bodies = []
var t = 0.1
var duration = 10
var multiplier

func _process(delta):
	t += delta
	
	multiplier = duration / (t + 1) / duration
	scale = Vector2(1,1) * multiplier * 2
	
	if t >= duration:
		queue_free()
	
	for i in range(len(bodies)):
		bodies[i].move_and_slide(bodies[i].global_position.direction_to(global_position) * (SPEED * multiplier))

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy") and not body in bodies:
		bodies.append(body)


func _on_Area2D_body_exited(body):
	if body in bodies:
		bodies.remove(bodies.find(body))
