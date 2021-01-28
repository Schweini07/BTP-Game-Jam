extends HBoxContainer

const HEART_SCENE := preload("res://scenes/ui/hearts/Heart.tscn")


func _ready() -> void:
	update_hearts()


func update_hearts() -> void:
	for heart in get_children():
		heart.queue_free()
	
	var num_full_hearts := Global.health / 10
	for i in num_full_hearts:
		var heart_instance = HEART_SCENE.instance()
		add_child(heart_instance)
	
	var num_hearts := float(Global.health) / 10
	var is_half_heart_needed: bool = num_hearts != num_full_hearts
	if is_half_heart_needed:
		var heart_instance := HEART_SCENE.instance()
		heart_instance.heart_type = heart_instance.HeartType.HALF
		add_child(heart_instance)
	
	var num_empty_hearts := 10 - ceil(num_hearts)
	for i in num_empty_hearts:
		var heart_instance := HEART_SCENE.instance()
		heart_instance.heart_type = heart_instance.HeartType.EMPTY
		add_child(heart_instance)
