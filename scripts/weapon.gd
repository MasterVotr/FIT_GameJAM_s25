extends Node

var is_attacking := false

func init(player_item := false) -> void:
	print("Weapon::init() -> not overriden")
	pass

func attack():
	print("Weapon::attack() -> not overriden")
	pass
