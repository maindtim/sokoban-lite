class_name SokobanGame
extends RefCounted
## Game state: move, push, undo, restart, win check. No nodes, fully testable headless.

signal moved(pushed: bool)
signal won(moves: int)

var level: SokobanLevel
var player := Vector2i.ZERO
var boxes := {}
var moves := 0
var pushes := 0
var _history: Array = []  # each: {player, boxes, pushed}


func _init(lv: SokobanLevel) -> void:
	level = lv
	restart()


func restart() -> void:
	player = level.player
	boxes = level.boxes.duplicate()
	moves = 0
	pushes = 0
	_history.clear()


func is_won() -> bool:
	for b in boxes:
		if not level.goals.has(b):
			return false
	return not boxes.is_empty()


func boxes_on_goal() -> int:
	var n := 0
	for b in boxes:
		if level.goals.has(b):
			n += 1
	return n


## Returns true if the player moved (with or without pushing).
func move(dir: Vector2i) -> bool:
	if is_won():
		return false
	var target := player + dir
	if level.walls.has(target):
		return false
	var pushed := false
	var snap := {"player": player, "boxes": boxes.duplicate(), "pushed": false}
	if boxes.has(target):
		var beyond := target + dir
		if level.walls.has(beyond) or boxes.has(beyond):
			return false
		boxes.erase(target)
		boxes[beyond] = true
		pushed = true
		pushes += 1
	snap["pushed"] = pushed
	_history.append(snap)
	player = target
	moves += 1
	moved.emit(pushed)
	if is_won():
		won.emit(moves)
	return true


func can_undo() -> bool:
	return not _history.is_empty()


func undo() -> bool:
	if _history.is_empty():
		return false
	var snap: Dictionary = _history.pop_back()
	player = snap["player"]
	boxes = snap["boxes"]
	moves -= 1
	if snap["pushed"]:
		pushes -= 1
	return true
