extends Control

signal upgrade_canceled

@onready var score: Label = $VBoxContainer/VBoxContainer/ScorePanel/VBoxContainer/HBoxContainer/Score

@onready var vitality_old: Label = $VBoxContainer/HBoxContainerUpgrades/VitalityUpgrade/VBoxContainer/HBoxContainer/OldStat
@onready var vitality_new: Label = $VBoxContainer/HBoxContainerUpgrades/VitalityUpgrade/VBoxContainer/HBoxContainer2/NewStat

@onready var strength_old: Label = $VBoxContainer/HBoxContainerUpgrades/StrengthUpgrade/VBoxContainer/HBoxContainer/OldStat
@onready var strength_new: Label = $VBoxContainer/HBoxContainerUpgrades/StrengthUpgrade/VBoxContainer/HBoxContainer2/NewStat

@onready var agility_old: Label = $VBoxContainer/HBoxContainerUpgrades/AgilityUpgrade/VBoxContainer/HBoxContainer/OldStat
@onready var agility_new: Label = $VBoxContainer/HBoxContainerUpgrades/AgilityUpgrade/VBoxContainer/HBoxContainer2/NewStat

var stat_upgrade: int


func _physics_process(delta: float) -> void:
	stat_upgrade = GameState.glob_lvl_score / GameState.stat_upgrade_cost
	score.text = str(GameState.glob_lvl_score)
	
	vitality_old.text = str(GameState.pl_stat_vitality)
	vitality_new.text = str(GameState.pl_stat_vitality + stat_upgrade)
	
	strength_old.text = str(GameState.pl_stat_strength)
	strength_new.text = str(GameState.pl_stat_strength + stat_upgrade)
	
	agility_old.text = str(GameState.pl_stat_agility)
	agility_new.text = str(GameState.pl_stat_agility + stat_upgrade)
	
func close_menu():
	self.hide()

func _on_vitality_upgrade_pressed() -> void:
	GameState.pl_stat_vitality += stat_upgrade
	print("Sacrifice: vitality stat upgraded")
	close_menu()


func _on_strength_upgrade_pressed() -> void:
	GameState.pl_stat_strength += stat_upgrade
	print("Sacrifice: strength stat upgraded")
	close_menu()


func _on_agility_upgrade_pressed() -> void:
	GameState.pl_stat_agility += stat_upgrade
	print("Sacrifice: agility stat upgraded")
	close_menu()


func _on_cancel_button_pressed() -> void:
	print("Sacrifice: canceled")
	emit_signal("upgrade_canceled")
	close_menu()
