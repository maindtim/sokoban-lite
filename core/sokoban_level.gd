class_name SokobanLevel
extends RefCounted
## A level grid. Text format (one char per cell):
##   '#' wall  ' ' floor  '.' goal  '$' box  '*' box on goal  '@' player  '+' player on goal
## Share code: rows joined with '|' (e.g. "#####|#@$.#|#####").

var width := 0
var height := 0
var walls := {}   # Vector2i -> true
var goals := {}   # Vector2i -> true
var boxes := {}   # Vector2i -> true
var player := Vector2i(-1, -1)
var error := ""


static func from_code(code: String) -> SokobanLevel:
	var rows := code.strip_edges().split("|")
	var lv := SokobanLevel.new()
	lv.height = rows.size()
	var players := 0
	for y in rows.size():
		lv.width = maxi(lv.width, rows[y].length())
		for x in rows[y].length():
			var c := rows[y][x]
			var p := Vector2i(x, y)
			match c:
				"#": lv.walls[p] = true
				".": lv.goals[p] = true
				"$": lv.boxes[p] = true
				"*":
					lv.boxes[p] = true
					lv.goals[p] = true
				"@":
					lv.player = p
					players += 1
				"+":
					lv.player = p
					lv.goals[p] = true
					players += 1
				" ": pass
				_: lv.error = "unknown character '%s' at %d,%d" % [c, x, y]
	if lv.error == "":
		lv.error = lv.validate(players)
	return lv


func validate(players: int = 1) -> String:
	if height == 0:
		return "empty level"
	if players != 1:
		return "need exactly one player (found %d)" % players
	if boxes.is_empty():
		return "need at least one box"
	if boxes.size() != goals.size():
		return "boxes (%d) and goals (%d) must match" % [boxes.size(), goals.size()]
	return ""


func is_valid() -> bool:
	return error == ""
