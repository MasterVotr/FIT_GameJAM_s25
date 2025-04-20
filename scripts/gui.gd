extends CanvasLayer

@onready var score_label: Label = $ScorePanel/HBoxContainer/Score
@onready var vitality_stat: Label = $StatsPanel/VBoxContainer/HBoxContainer/VitalityStat
@onready var strength_stat: Label = $StatsPanel/VBoxContainer/HBoxContainer2/StrengthStat
@onready var agility_stat: Label = $StatsPanel/VBoxContainer/HBoxContainer3/AgilityStat


func _physics_process(delta: float) -> void:
	score_label.text = str(GameState.glob_lvl_score)
	vitality_stat.text = str(GameState.pl_stat_vitality)
	strength_stat.text = str(GameState.pl_stat_strength)
	agility_stat.text = str(GameState.pl_stat_agility)
