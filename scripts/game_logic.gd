extends Node2D


const player_start_pos = Vector2(229, 272)

enum ROOT_CHILD_ORDER {
	LEVEL_BACKGROUND,
	PLAYER,
	RESETABLE_OBJECTS
}

func _ready() -> void:
	self.get_child(ROOT_CHILD_ORDER.PLAYER).position = player_start_pos
	pass


func reload_world() -> void:
	self.get_child(ROOT_CHILD_ORDER.PLAYER).position = player_start_pos
	for node in self.get_child(ROOT_CHILD_ORDER.RESETABLE_OBJECTS).get_children():
		if node.has_method("reset"):
			node.reset()
	pass
