class_name BoardView
extends Control
## Draws a SokobanGame with code only (no art files needed).

const C_VOID := Color("1b1f2e")
const C_FLOOR := Color("e9dcc0")
const C_WALL := Color("5b6486")
const C_GOAL := Color("e8704f")
const C_BOX := Color("c98a3d")
const C_BOX_DONE := Color("6fbf73")
const C_PLAYER := Color("3b6fd1")

var game: SokobanGame


func set_game(g: SokobanGame) -> void:
	game = g
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), C_VOID)
	if game == null:
		return
	var lv := game.level
	var cs := floorf(minf(size.x / (lv.width + 1), size.y / (lv.height + 1)))
	var o := (size - Vector2(lv.width, lv.height) * cs) / 2.0
	for y in lv.height:
		for x in lv.width:
			var p := Vector2i(x, y)
			var r := Rect2(o + Vector2(p) * cs, Vector2(cs, cs))
			draw_rect(r, C_WALL if lv.walls.has(p) else C_FLOOR)
	for p in lv.goals:
		var c := o + (Vector2(p) + Vector2(0.5, 0.5)) * cs
		draw_circle(c, cs * 0.2, C_GOAL)
		draw_circle(c, cs * 0.1, C_FLOOR)
	for b in game.boxes:
		var m := cs * 0.12
		var col := C_BOX_DONE if lv.goals.has(b) else C_BOX
		draw_rect(Rect2(o + Vector2(b) * cs + Vector2(m, m), Vector2(cs - 2 * m, cs - 2 * m)), col)
	var pc := o + (Vector2(game.player) + Vector2(0.5, 0.5)) * cs
	draw_circle(pc, cs * 0.34, C_PLAYER)
