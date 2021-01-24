extends Node2D

var chunks_num : Vector2 = Vector2(2, 2)
var chunks = []
var chunk_size = 70

func _ready():
	randomize()
	
	Generator.size = chunk_size+2
	Generator.room_frequency = 14
	for i in range(chunks_num.x):
		chunks.append([])
		for j in range(chunks_num.y):
			Generator.maze = []
			chunks[i].append(Generator.generate())
			
	draw()
	add_frame()

func draw():
	var current
	var offset = Vector2(0,0)
	for i in range(len(chunks)):
		for j in range(len(chunks[i])):
			current = remove_frame(chunks[i][j][0])
			offset = Vector2(i*2,j*2)
			for k in range(len(current)):
				for l in range(len(current[k])):
					if current[k][l] == "wall":
						$walls.set_cell(i*chunk_size+k-offset.x, j*chunk_size+l-offset.y, 0)

func remove_frame(arr):
	for i in range(len(arr)):
		for j in range(len(arr)):
			if i < 2 or j < 2 or i > len(arr)-3 or j > len(arr[i])-3:
				arr[i][j] = "visited"
	return arr

func add_frame():
	for i in range(chunks_num.x*chunk_size):
		for j in range(chunks_num.y*chunk_size):
			if i == 0 or j == 0:
				$walls.set_cell(i, j, 0)
			if i == chunks_num.x*chunk_size-1 or j == chunks_num.y*chunk_size-1:
				$walls.set_cell(i, j, 0)
