extends Node2D

var chunks_num : Vector2 = Vector2(2, 2)
var chunks = []

func _ready():
	randomize()
	
	Generator.size = 70
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
	for i in range(len(chunks)):
		for j in range(len(chunks[i])):
			current = chunks[i][j][0]
			for k in range(len(current)):
				for l in range(len(current[k])):
					if current[k][l] == "wall":
						$walls.set_cell(i*70+k, j*70+l, 0)
						
func add_frame():
	for i in range(chunks_num.x*70):
		for j in range(chunks_num.y*70):
			if i == 0 or j == 0:
				$walls.set_cell(i, j, 0)
			if i == chunks_num.x*70-1 or j == chunks_num.y*70-1:
				$walls.set_cell(i, j, 0)
