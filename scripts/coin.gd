extends Area2D

var disabled = false

func _on_body_entered(body: Node2D) -> void:
	if disabled:
		return
		
	# Add optional checks on input if needed
	
	# Change values in player script
	body.add_coin()
	
	# do some magic with particles and what not here
	
	disabled = true
	hide() 

func reset() -> void:
	disabled = false
	show()
