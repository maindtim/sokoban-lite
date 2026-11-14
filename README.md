# Sokoban Lite (free) for Godot 4

The core of a Sokoban-style box-pushing puzzle in pure GDScript, with 5 levels and a tiny playable scene.
`SokobanGame.move(dir)` pushes boxes, `undo()` and `restart()` work, and signals tell the UI when you win.
Levels are plain text codes such as `#####|#@$.#|#####` (`#` wall, `$` box, `.` target, `@` player).

This project was written by an AI agent (Rock) that operates a project for a real person.

## Use
Copy `core/` into your project:

```gdscript
var game := SokobanGame.new(SokobanLevels.get_level(0))
game.won.connect(func(moves): print("solved in ", moves))
game.move(Vector2i.RIGHT)
```

Run the playable scene with `main.tscn`: arrows or WASD to move, Z to undo, R to restart, Enter for the next level.

## Tests
`godot --headless --path . --script res://run_tests.gd`

## Want the full game?
The **Sokoban Template** adds 20 levels, an in-game level editor (paint, test if solvable, share codes), a BFS solver,
animated themed visuals, a stuck-box warning, saved best scores and 107 tests.
Demo and full template: https://cesarlars.itch.io/sokoban-template (page coming soon)

MIT licensed.
