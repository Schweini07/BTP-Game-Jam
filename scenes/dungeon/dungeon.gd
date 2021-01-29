extends Node2D

const CHUNK_SIZE := 70
const CHUNKS_NUM := Vector2(2, 2)
const door = preload("res://scenes/dungeon/doors/doors.tscn")

var chunks = []
var doors = []

onready var tilemap = get_node("../Navigation2D/TileMap")
onready var rooms = $rooms
onready var player = get_node("../Player")

var neighbors = [
	Vector2(0,1),
	Vector2(0,-1),
	Vector2(1,0),
	Vector2(-1,0),
	Vector2(1,-1),
	Vector2(-1,-1),
	Vector2(-1,1),
	Vector2(1,1),
]

func _ready():
	if Global.tutorial:
		return
	
	get_parent().get_node("Tutorial").queue_free()
	
	randomize()

	Generator.size = CHUNK_SIZE + 2
	Generator.room_frequency = 14
	for i in range(CHUNKS_NUM.x):
		chunks.append([])
		for _j in range(CHUNKS_NUM.y):
			Generator.maze = []
			chunks[i].append(Generator.generate())

	draw()
	add_frame()
	tilemap.update_bitmask_region()
	add_rooms()
	add_doors()

	get_node("../Player").position = chunks[0][0][1].position + Vector2(72, 72)


func add_rooms():
	for i in range(len(chunks)):
		for j in range(len(chunks[i])):
			for k in range(len(chunks[i][j]) - 1):
				chunks[i][j][k + 1].position += Vector2(i * (CHUNK_SIZE-2) * 32, j * (CHUNK_SIZE-2) * 32)
				rooms.add_child(chunks[i][j][k + 1])


func draw():
	var inst
	var current
	var offset = Vector2(0, 0)
	for i in range(len(chunks)):
		for j in range(len(chunks[i])):
			current = remove_frame(chunks[i][j][0])
			offset = Vector2(i * 2, j * 2)
			for k in range(len(current)):
				for l in range(len(current[k])):
					if current[k][l] == "wall":
						tilemap.set_cell(
							i * CHUNK_SIZE + k - offset.x, j * CHUNK_SIZE + l - offset.y, 1
						)
					else:
						tilemap.set_cell(
							i * CHUNK_SIZE + k - offset.x, j * CHUNK_SIZE + l - offset.y, 0
						)

					if current[k][l] == "exit":
						inst = door.instance()
						inst.position = Vector2(i * (CHUNK_SIZE - 2) + k, j * (CHUNK_SIZE - 2) + l) * 32 + Vector2(16, 16)
						doors.append(inst)

func add_doors():
	for i in range(len(doors)):
		add_child(doors[i])

func remove_frame(arr):
	for i in range(len(arr)):
		for j in range(len(arr)):
			if i < 2 or j < 2 or i > len(arr) - 3 or j > len(arr[i]) - 3:
				arr[i][j] = "visited"
	return arr


func add_frame():
	for i in range(CHUNKS_NUM.x * CHUNK_SIZE):
		for j in range(CHUNKS_NUM.y * CHUNK_SIZE):
			if i == 0 and j != 0:
					tilemap.set_cell(1, j, 1)
					tilemap.set_cell(0, j, -1)
			if j == 0 and i != 0:
				tilemap.set_cell(i, 1, 1)
				tilemap.set_cell(i, 0, -1)
			if i == CHUNKS_NUM.x * CHUNK_SIZE - 1 or j == CHUNKS_NUM.y * CHUNK_SIZE - 1:
				tilemap.set_cell(i, j, 1)
				tilemap.set_cell(i+1, j+1, -1)

	tilemap.set_cell(0, 0, -1)
	tilemap.set_cell(CHUNKS_NUM.x * CHUNK_SIZE, 0, -1)
	tilemap.set_cell(CHUNKS_NUM.x * CHUNK_SIZE, -1, -1)
	tilemap.set_cell(-1, CHUNKS_NUM.x * CHUNK_SIZE, -1)
	tilemap.set_cell(0, CHUNKS_NUM.x * CHUNK_SIZE, -1)
