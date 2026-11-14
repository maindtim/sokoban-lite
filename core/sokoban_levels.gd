class_name SokobanLevels
extends RefCounted
## The 5 levels of the free Lite edition.

const CODES := [
	"#####|#@$.#|#####",
	"######|#@ $.#|######",
	"#######|#  .  #|#@ $  #|#     #|#######",
	"#####|#.  #|#$# #|# @ #|#####",
	"######|#.   #|# $$ #|# .@ #|######",
]


static func count() -> int:
	return CODES.size()


static func get_level(i: int) -> SokobanLevel:
	return SokobanLevel.from_code(CODES[i])
