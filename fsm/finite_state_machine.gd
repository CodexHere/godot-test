extends Node
class_name FiniteStateMachine

@export var state: State
@export var context: Context

func _ready() -> void:
	for child in state.children:
		print("Got State: ", child)
		child.root_context = self.context
