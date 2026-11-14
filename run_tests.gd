extends SceneTree
## godot --headless --path <this folder> --script res://run_tests.gd

var _passed := 0
var _failed := 0


func _check(ok: bool, label: String) -> void:
	if ok:
		_passed += 1
	else:
		_failed += 1
		print("FAIL: ", label)


func _play(g: SokobanGame, keys: String) -> void:
	var dirs := {"U": Vector2i.UP, "D": Vector2i.DOWN, "L": Vector2i.LEFT, "R": Vector2i.RIGHT}
	for k in keys:
		g.move(dirs[k])


func _init() -> void:
	for i in SokobanLevels.count():
		_check(SokobanLevels.get_level(i).is_valid(), "level %d valid" % (i + 1))
	_check(not SokobanLevel.from_code("#####|#@@$.#|#####").is_valid(), "two players rejected")
	_check(not SokobanLevel.from_code("#####|#@$ #|#####").is_valid(), "boxes/goals must match")
	_check(not SokobanLevel.from_code("#####|#@x.#|#####").is_valid(), "unknown char rejected")

	var g := SokobanGame.new(SokobanLevels.get_level(0))
	_check(not g.is_won(), "level 1 starts unsolved")
	_check(g.move(Vector2i.RIGHT), "push the box")
	_check(g.is_won() and g.pushes == 1 and g.moves == 1, "level 1 solved in one push")
	_check(not g.move(Vector2i.LEFT), "no moves after winning")
	_check(g.undo() and not g.is_won() and g.moves == 0, "undo restores state")
	g.restart()
	_check(g.moves == 0 and not g.can_undo(), "restart clears history")

	var g2 := SokobanGame.new(SokobanLevels.get_level(1))
	_play(g2, "RR")
	_check(g2.is_won() and g2.moves == 2, "level 2 solved with RR")

	var g3 := SokobanGame.new(SokobanLevels.get_level(0))
	_check(not g3.move(Vector2i.LEFT), "wall blocks the player")
	g3.move(Vector2i.RIGHT)
	var g4 := SokobanGame.new(SokobanLevel.from_code("######|#@$$.#|######"))
	_check(not g4.move(Vector2i.RIGHT), "cannot push two boxes")

	print("%d passed, %d failed" % [_passed, _failed])
	quit(1 if _failed > 0 else 0)
