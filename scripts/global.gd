extends Node

signal normal_enemy_killed
signal boss_killed
signal kill_criteria_reached
signal request_info

var health := 100
var tutorial: bool = false
var camera: Camera2D

# Upgrades
var has_speed_upgrade: bool = false
var has_dash: bool = false
var has_rapid_fire: bool = false
var has_no_reload: bool = false
var has_flaming_bullets: bool = false
var has_immobolizing_bullets: bool = false
var has_blackhole: bool = false
var has_massive_bullets: bool = false
var has_ghost_bullets: bool = false

var ib_timed_out: bool = true
var has_hat: bool = false


func reset() -> void:
	health = 100
	tutorial = false
	camera = null

	has_speed_upgrade = false
	has_dash = false
	has_rapid_fire = false
	has_no_reload = false
	has_flaming_bullets = false
	has_immobolizing_bullets = false
	has_blackhole = false
	has_massive_bullets = false
	has_ghost_bullets = false

	ib_timed_out = true
	has_hat = false
