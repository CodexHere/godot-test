# State.gd
extends Resource
class_name State

@export var state_name: String
@export var children: Array[State] = []

var fsm: FiniteStateMachine
var root_context: Context
