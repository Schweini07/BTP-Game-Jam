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

func draw():
	var current
	for i in range(len(chunks)):
		for j in range(len(chunks[i])):
			current = chunks[i][j][0]
			for k in range(len(current)):
				for l in range(len(current[k])):
					if current[k][l] == "wall":
						$walls.set_cell(i*70+k, j*70+l, 0)
