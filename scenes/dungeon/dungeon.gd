extends Node2D

var chunks_num: Vector2 = Vector2(2, 2)
var chunks = []
var chunk_size = 70

onready var tilemap = get_node("../Navigation2D/TileMap")
onready var rooms = $rooms


func _ready():
	randomize()

	Generator.size = chunk_size + 2
	Generator.room_frequency = 14
	for i in range(chunks_num.x):
		chunks.append([])
		for _j in range(chunks_num.y):
			Generator.maze = []
			chunks[i].append(Generator.generate())

	# tmp, so i don't remove mario's test map. you're welcome
	tilemap.clear()

	draw()
	add_frame()
	add_rooms()


func add_rooms():
	for i in range(len(chunks)):
		for j in range(len(chunks[i])):
			for k in range(len(chunks[i][j]) - 1):
				chunks[i][j][k + 1].position += Vector2(i * 70 * 64, j * 70 * 64)
				rooms.add_child(chunks[i][j][k + 1])


func draw():
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
							i * chunk_size + k - offset.x, j * chunk_size + l - offset.y, 1
						)
					else:
						tilemap.set_cell(
							i * chunk_size + k - offset.x, j * chunk_size + l - offset.y, 0
						)

	tilemap.update_bitmask_region()


func remove_frame(arr):
	for i in range(len(arr)):
		for j in range(len(arr)):
			if i < 2 or j < 2 or i > len(arr) - 3 or j > len(arr[i]) - 3:
				arr[i][j] = "visited"
	return arr


func add_frame():
	for i in range(chunks_num.x * chunk_size):
		for j in range(chunks_num.y * chunk_size):
			if i == 0 or j == 0:
				tilemap.set_cell(i, j, 1)
			if i == chunks_num.x * chunk_size - 1 or j == chunks_num.y * chunk_size - 1:
				tilemap.set_cell(i, j, 1)
	tilemap.update_bitmask_region()
