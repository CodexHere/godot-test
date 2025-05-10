# Context.gd
extends Resource
class_name Context

@export_group("Player Info")
@export var player_node_path: NodePath
@export var player_name = 'CodexHere'
@export var player_highlight_color = Color (255, 50, 255)
@export var player_anim_start = "Idle"
@export var player_anim_path = "mixamo_something"
@export var player_basis = Basis.IDENTITY
