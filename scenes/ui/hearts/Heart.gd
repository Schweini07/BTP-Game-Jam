extends Control

var id : int

onready var full_heart: TextureRect = $FullHeart
onready var half_heart: TextureRect = $HalfHeart
onready var empty_heart: TextureRect = $EmptyHeart

func sacrifice() -> void:
	full_heart.hide()
	empty_heart.show()
