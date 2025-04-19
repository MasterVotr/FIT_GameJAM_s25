extends Node2D

signal health_depleted
signal health_changed(old_value, new_value)

@export var max_health: int
@export var health: int
@export var is_dead := false

var dmg_popup = preload("res://scenes/damage_popup.tscn")
var popup_color = Color(1.0, 1.0, 1.0, 1.0)		#NOTE: doesn't work, dunno why

func _init(max_health: int):
	self.max_health = max_health
	self.health = self.max_health
	self.is_dead = self.max_health <= 0

func spawn_popup(value: int) -> void:
	var popup = dmg_popup.instantiate()
	popup.set_value(value)
	popup.set_color(popup_color)
	self.add_child(popup)

func take_damage(amount: int):
	var old_health = health
	health -= amount
	health_changed.emit(old_health, health)
	
	spawn_popup(amount)
	
	if health > max_health:
		health = max_health
	if health <= 0:
		health = 0
		is_dead = true
		health_depleted.emit()
		
func reset() -> void:
	self.health = self.max_health
	self.is_dead = false

func _process(delta: float) -> void:
	pass
