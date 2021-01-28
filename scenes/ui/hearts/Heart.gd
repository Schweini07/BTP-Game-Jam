extends Control

enum HeartType {
	FULL,
	HALF,
	EMPTY
}

export (HeartType) var heart_type = HeartType.FULL setget set_heart_type

var hearts = {
	HeartType.FULL: full_heart,
	HeartType.HALF: half_heart,
	HeartType.EMPTY: empty_heart
}

onready var full_heart: TextureRect = $FullHeart
onready var half_heart: TextureRect = $HalfHeart
onready var empty_heart: TextureRect = $EmptyHeart


func set_heart_type(type: int) -> void:
	heart_type = type
	
	if not full_heart:
		full_heart = $FullHeart
	if not half_heart:
		half_heart = $HalfHeart
	if not empty_heart:
		empty_heart = $EmptyHeart
	
	match heart_type:
		HeartType.FULL:
			full_heart.show()
			half_heart.hide()
			empty_heart.hide()
		HeartType.HALF:
			full_heart.hide()
			half_heart.show()
			empty_heart.hide()
		HeartType.EMPTY:
			full_heart.hide()
			half_heart.hide()
			empty_heart.show()
