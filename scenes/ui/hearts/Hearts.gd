extends HBoxContainer

var heart: PackedScene = preload("res://scenes/ui/hearts/Heart.tscn")

func _ready():
	for i in 10:
		var heart_instance : Control = heart.instance()
		heart_instance.id = i
		add_child(heart_instance)
