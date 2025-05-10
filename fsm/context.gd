# Context.gd
extends Resource
class_name Context


@export_group("Player Info")
@export var player: Dictionary = {
	'start_animation': 'Idle',
	'spawn_position': Vector3(0,0,0),
	'highlight_color': Color(255, 0, 255)
}
