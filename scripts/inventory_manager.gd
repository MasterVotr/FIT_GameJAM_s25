extends Control

var weapons : Array = []
var cur_idx = 0

@onready var main_slot : TextureRect
@onready var left_slot : TextureRect
@onready var right_slot : TextureRect
@onready var cooldown_bar : ProgressBar

var full_color := Color(1.0, 1.0, 1.0, 1.0)
var opaque_color := Color(1.0, 1.0, 1.0, 0.5)

var main_size := Vector2(160, 160)
var side_size := Vector2(140, 140)

func _ready() -> void:
	main_slot = self.find_child("slot_panel_2").find_child("item_texture")
	left_slot = self.find_child("slot_panel_1").find_child("item_texture")
	right_slot = self.find_child("slot_panel_3").find_child("item_texture")
	cooldown_bar = self.find_child("slot_panel_2").find_child("cooldown_bar")

func update_visual() -> void:
	if main_slot == null or left_slot == null or right_slot == null:
		_ready()
	
	if weapons.size() == 0:
		main_slot.texture = null
		left_slot.texture = null
		right_slot.texture = null
	
	# set main weapon
	main_slot.texture = weapons[cur_idx].get_icon_texture()
	main_slot.modulate = full_color
	left_slot.modulate = opaque_color
	right_slot.modulate = opaque_color
	
	main_slot.rotation = 0.0
	left_slot.rotation = 0.0
	right_slot.rotation = 0.0
	
	main_slot.size = main_size
	left_slot.size = side_size
	right_slot.size = side_size
	
	if weapons.size() == 2:
		if cur_idx == 1:
			left_slot.texture = weapons[cur_idx - 1].get_icon_texture()
		else:
			right_slot.texture = weapons[cur_idx + 1].get_icon_texture()
	elif weapons.size() >= 3:
		left_slot.texture = weapons[(cur_idx - 1 + weapons.size()) % weapons.size()].get_icon_texture()
		right_slot.texture = weapons[(cur_idx + 1) % weapons.size()].get_icon_texture()


func _process(delta: float) -> void:
	if cooldown_bar == null:
		cooldown_bar = self.find_child("slot_panel_2").find_child("cooldown_bar")
	
	cooldown_bar.max_value = weapons[cur_idx].find_child("Cooldown").wait_time
	cooldown_bar.value = cooldown_bar.max_value - weapons[cur_idx].find_child("Cooldown").time_left


func reset_inventory() -> void:
	cur_idx = 0
	weapons.clear()
	update_visual()

func add_weapon(weapon_scene: Node2D) -> void:
	weapons.append(weapon_scene)
	update_visual()
	
func get_current_weapon() -> Node2D:
	return weapons[cur_idx]
	
func shift_left() -> void:
	cur_idx = (cur_idx - 1 + weapons.size()) % weapons.size()
	update_visual()

func shift_right() -> void:
	cur_idx = (cur_idx + 1) % weapons.size()
	update_visual()
