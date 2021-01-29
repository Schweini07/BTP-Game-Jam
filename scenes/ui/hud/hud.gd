extends CanvasLayer

var num_kills := 0
var blackhole_cooldown_used: bool = false
var ib_cooldown_used: bool = false

onready var hearts: HBoxContainer = $MarginContainer/VBoxContainer/Hearts
onready var kill_counter_label: Label = $MarginContainer/VBoxContainer/KillCounter/Label
onready var blackhole_cooldown: TextureProgress = $MarginContainer/VBoxContainer/BlackholeCooldown
onready var ib_cooldown: TextureProgress = $MarginContainer/VBoxContainer/IBCooldown

func _ready():
	Global.connect("normal_enemy_killed", self, "increment_kill_counter")
	
	if Global.has_blackhole:
		blackhole_cooldown.show()
	if Global.has_immobolizing_bullets:
		ib_cooldown.show()


func _on_Player_hurt():
	hearts.update_hearts()


func increment_kill_counter():
	num_kills += 1
	if num_kills == 30:
		Global.emit_signal("kill_criteria_reached")
	kill_counter_label.text = "%d/30" % num_kills

func start_blackhole_cooldown() -> void:
	blackhole_cooldown_used = true
	blackhole_cooldown.value = 0
	for i in 100:
		yield(get_tree().create_timer(.19), "timeout")
		blackhole_cooldown.value += 1

func start_ib_cooldown() -> void:
	ib_cooldown_used = true
	ib_cooldown.value = 0
	for i in 100:
		yield(get_tree().create_timer(.05), "timeout")
		ib_cooldown.value += 1
