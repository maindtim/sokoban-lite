extends Control
## Minimal playable scene: arrows/WASD to move, Z undo, R restart, Enter for the next level.

var game: SokobanGame
var board: BoardView
var level_index := 0
var _label: Label


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	board = BoardView.new()
	board.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(board)
	_label = Label.new()
	_label.position = Vector2(16, 12)
	add_child(_label)
	start_level(0)


func start_level(i: int) -> void:
	level_index = clampi(i, 0, SokobanLevels.count() - 1)
	game = SokobanGame.new(SokobanLevels.get_level(level_index))
	game.moved.connect(func(_p): _refresh())
	game.won.connect(func(_m): _refresh())
	board.set_game(game)
	_refresh()


func _refresh() -> void:
	var status := "  SOLVED! Press Enter" if game.is_won() else ""
	_label.text = "Level %d / %d   Moves: %d   (Z undo, R restart)%s" % [level_index + 1, SokobanLevels.count(), game.moves, status]
	board.queue_redraw()


func _unhandled_key_input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	match (event as InputEventKey).keycode:
		KEY_UP, KEY_W: game.move(Vector2i.UP)
		KEY_DOWN, KEY_S: game.move(Vector2i.DOWN)
		KEY_LEFT, KEY_A: game.move(Vector2i.LEFT)
		KEY_RIGHT, KEY_D: game.move(Vector2i.RIGHT)
		KEY_Z: game.undo()
		KEY_R: game.restart()
		KEY_ENTER:
			if game.is_won():
				start_level(level_index + 1)
	_refresh()
