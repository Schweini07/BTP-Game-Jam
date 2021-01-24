extends Node

# TODO: make the paths more filtered.
# TODO: chunks

var maze = []

# map of posible maze checks
var move_map = {
	0: Vector2(0, 1),
	1: Vector2(0, -1),
	2: Vector2(1, 0),
	3: Vector2(-1, 0),
	4: Vector2(-1, -1),
	5: Vector2(-1, 1),
	6: Vector2(1, -1),
	7: Vector2(1, 1),
}
var def_maze
# size of maze. will be one more
var size = 100
# frequency at which rooms are placed. size/frequency
var room_frequency = 14


# basic room class
class Room:
	var pos
	var size
	var maze
	var max_exits = 4
	var max_size = 10
	var min_size = 5
	var max_offset = 4
	var box_chance

	func generate():
		size = Vector2(randi() % max_size + min_size, randi() % max_size + min_size)
		pos.x += randi() % max_offset
		pos.y += randi() % max_offset
		box_chance = randi()%10
		if pos.x + size.x > len(maze) - 1 or pos.y + size.y > len(maze[0]) - 1:
			self.size = Vector2(0, 0)

	func add_to_maze():
		var exits = [0, 0, 0, 0]
		var exits_total = 0
		for i in range(size.x):
			for j in range(size.y):
				if i == 0:
					if maze[pos.x + i - 1][pos.y + j] != "visited" or exits[0] > max_exits:
						maze[pos.x + i][pos.y + j] = "wall"
					else:
						maze[pos.x + i][pos.y + j] = "visited"
						exits[0] += 1
				elif j == 0:
					if maze[pos.x + i][pos.y + j - 1] != "visited" or exits[1] > max_exits:
						maze[pos.x + i][pos.y + j] = "wall"
					else:
						maze[pos.x + i][pos.y + j] = "visited"
						exits[1] += 1
				elif i == size.x - 1:
					if maze[pos.x + i + 1][pos.y + j] != "visited" or exits[2] > max_exits:
						maze[pos.x + i][pos.y + j] = "wall"
					else:
						maze[pos.x + i][pos.y + j] = "visited"
						exits[2] += 1
				elif j == size.y - 1:
					if maze[pos.x + i][pos.y + j + 1] != "visited" or exits[3] > max_exits:
						maze[pos.x + i][pos.y + j] = "wall"
					else:
						maze[pos.x + i][pos.y + j] = "visited"
						exits[3] += 1
				else:
					maze[pos.x + i][pos.y + j] = "visited"

		for i in range(len(exits)):
			exits_total += exits[i]
		if exits_total < 2:
			add_exits()

		return maze

	func add_exits():
		var move_map = {
			0: Vector2(0, 1),
			1: Vector2(0, -1),
			2: Vector2(1, 0),
			3: Vector2(-1, 0),
		}
		var exit_pos
		for i in range(4):
			exit_pos = pos + move_map[i] * (randi() % min_size)
			if maze[exit_pos.x][exit_pos.y] == "wall":
				maze[exit_pos.x][exit_pos.y] = "visited"
				exit_pos += move_map[i]
			else:
				continue

	func get_scene():
		var inst = load("res://scenes/dungeon/room/room.tscn").instance()
		inst.global_position = pos * 64
		inst.wh = size
		inst.box_chance = box_chance
		return inst


func generate():
	for i in range(size + 1):
		maze.append([])
		for j in range(size + 1):
			if i == 0 or j == 0:
				maze[i].append("visited")
			elif i == size or j == size:
				maze[i].append("visited")
			else:
				maze[i].append("wall")
	def_maze = maze
	g(Vector2(1, 1))

	var rooms = []
	var room
	for i in range(len(maze) / room_frequency):
		for j in range(len(maze[i]) / room_frequency):
			room = Room.new()
			room.pos = Vector2(i, j) * room_frequency
			room.maze = maze
			room.generate()
			maze = room.add_to_maze()
			rooms.append(room)

	var tr = []
	tr.append(maze)
	for i in range(len(rooms)):
		tr.append(rooms[i].get_scene())

	# returns instances for dungeon to add
	# maze is always zero
	return tr


func draw():
	var walls = TileMap.new()
	walls.tile_set = load("res://assets/tilesets/walls.tres")
	for i in range(len(maze)):
		for j in range(len(maze[i])):
			if maze[i][j] == "wall":
				walls.set_cell(i, j, 0)
	return walls


func get_unvisited(pos):
	var unvisited = []
	for i in range(4):
		if (
			(pos.x + move_map[i].x) * 2 < len(maze)
			and (pos.y + move_map[i].y) * 2 < len(maze[(pos.x + move_map[i].x) * 2])
		):
			if maze[(pos.x + move_map[i].x) * 2][(pos.y + move_map[i].y) * 2] != "visited":
				unvisited.append(i)
				
	return unvisited

func g(pos):
	if maze[pos.x * 2][pos.y * 2] == "visited":
		return
	maze[pos.x * 2][pos.y * 2] = "visited"

	var done = []
	var npos
	var rng
	var unvisited = get_unvisited(pos)

	if len(unvisited) < 1:
		#for i in range(4):
		#	maze[pos.x*2+move_map[i].x][pos.y*2+move_map[i].y] = "visited"
		for _i in range(4):
			maze[pos.x * 2 + randi() % 3 - 1][pos.y * 2 - randi() % 3 - 1] = "visited"

		if len(get_unvisited(pos)) < 2:
			maze[pos.x * 2][pos.y * 2] = "upgrade"

		return
	else:
		while len(done) < len(unvisited):
			rng = randi() % len(unvisited)
			if not rng in done:
				maze[pos.x * 2 + move_map[unvisited[rng]].x][pos.y * 2 + move_map[unvisited[rng]].y] = "visited"
				npos = pos + move_map[unvisited[rng]]
				g(npos)
				done.append(rng)
				unvisited = []
				for i in range(4):
					if (
						(pos.x + move_map[i].x) * 2 < len(maze)
						and (pos.y + move_map[i].y) * 2 < len(maze[(pos.x + move_map[i].x) * 2])
					):
						if (
							maze[(pos.x + move_map[i].x) * 2][(pos.y + move_map[i].y) * 2]
							!= "visited"
						):
							unvisited.append(i)
