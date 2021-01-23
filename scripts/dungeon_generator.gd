extends Node2D

var maze = []
var move_map = {
	0: Vector2(0,1),
	1: Vector2(0,-1),
	2: Vector2(1,0),
	3: Vector2(-1,0),
	4: Vector2(-1,-1),
	5: Vector2(-1,1),
	6: Vector2(1,-1),
	7: Vector2(1,1),
}
var def_maze

class Room:
	var pos
	var size
	var maze
	
	func generate():
		size = Vector2(randi()%10+5, randi()%10+5)
		pos.x += randi()%4
		pos.y += randi()%4
		if pos.x+size.x > len(maze)-1 or pos.y+size.y > len(maze[0])-1:
			self.size = Vector2(0,0)
	
	func add_to_maze():
		var exits = [0, 0, 0, 0]
		for i in range(size.x):
			for j in range(size.y):
				if i == 0:
					if maze[pos.x+i-1][pos.y+j] != "visited" or exits[0] > 2:
						maze[pos.x+i][pos.y+j] = "wall"
					else:
						maze[pos.x+i][pos.y+j] = "visited"
						exits[0] += 1
				elif j == 0: 
					if maze[pos.x+i][pos.y+j-1] != "visited" or exits[1] > 2:
						maze[pos.x+i][pos.y+j] = "wall"
					else:
						maze[pos.x+i][pos.y+j] = "visited"
						exits[1] += 1
				elif i == size.x-1:
					if maze[pos.x+i+1][pos.y+j] != "visited" or exits[2] > 2:
						maze[pos.x+i][pos.y+j] = "wall"
					else:
						maze[pos.x+i][pos.y+j] = "visited"
						exits[2] += 1
				elif j == size.y-1:
					if maze[pos.x+i][pos.y+j+1] != "visited" or exits[3] > 2:
						maze[pos.x+i][pos.y+j] = "wall"
					else:
						maze[pos.x+i][pos.y+j] = "visited"
						exits[3] += 1
				else:
					maze[pos.x+i][pos.y+j] = "visited"
					
		return maze

func _ready():
	randomize()
	
	for i in range(101):
		maze.append([])
		for j in range(101):
			if i == 0 or j == 0:
				maze[i].append("visited")
			elif i == 100 or j == 100:
				maze[i].append("visited")
			else:
				maze[i].append("wall")
	def_maze = maze
	g(Vector2(1,1))
	
	var rooms = []
	var room
	for i in range(len(maze)/14):
		for j in range(len(maze[i])/14):
			room = Room.new()
			room.pos = Vector2(i, j)*14
			room.maze = maze
			room.generate()
			maze = room.add_to_maze()
			rooms.append(room)
	
	draw()
	
func draw():
	for i in range(len(maze)):
		for j in range(len(maze[i])):
			if maze[i][j] == "wall":
				$walls.set_cell(i, j, 0)

func g(pos):
	if maze[pos.x*2][pos.y*2] == "visited":
		return
	maze[pos.x*2][pos.y*2] = "visited"
	
	var unvisited = []
	var done = []
	var npos
	var rng
	for i in range(4):
		if (pos.x+move_map[i].x)*2 < len(maze) and (pos.y+move_map[i].y)*2 < len(maze[(pos.x+move_map[i].x)*2]):
			if maze[(pos.x+move_map[i].x)*2][(pos.y+move_map[i].y)*2] != "visited":
				unvisited.append(i)
	
	if len(unvisited) < 1:
		maze[pos.x*2+randi()%3-1][pos.y*2-randi()%3-1] = "visited"
		maze[pos.x*2+randi()%3-1][pos.y*2-randi()%3-1] = "visited"
		maze[pos.x*2+randi()%3-1][pos.y*2-randi()%3-1] = "visited"
		return
	else:
		while len(done) < len(unvisited):
			rng = randi()%len(unvisited)
			if not rng in done:
				maze[pos.x*2+move_map[unvisited[rng]].x][pos.y*2+move_map[unvisited[rng]].y] = "visited"
				npos = pos+move_map[unvisited[rng]]
				g(npos)
				done.append(rng)
				unvisited = []
				for i in range(3):
					if (pos.x+move_map[i].x)*2 < len(maze) and (pos.y+move_map[i].y)*2 < len(maze[(pos.x+move_map[i].x)*2]):
						if maze[(pos.x+move_map[i].x)*2][(pos.y+move_map[i].y)*2] != "visited":
							unvisited.append(i)
