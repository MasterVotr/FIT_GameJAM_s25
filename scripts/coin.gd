extends Area2D

var disabled = false

func _on_body_entered(body: Node2D) -> void:
	if disabled:
		return
		
	GameState.glob_lvl_score += GameState.score_coin
	
	disabled = true
	hide() 

func reset() -> void:
	disabled = false
	show()
