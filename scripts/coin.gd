extends Area2D

var disabled = false

func _on_body_entered(body: Node2D) -> void:
	if disabled:
		return
		
	# done as such to make casting damage to player easy af
	body.add_coin()
	
	disabled = true
	hide() 

func reset() -> void:
	disabled = false
	show()
