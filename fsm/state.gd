# State.gd
extends Resource
class_name State

@export var state_name: String
@export var context: Context
@export var children: Array[State] = []
