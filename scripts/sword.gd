extends Node2D

var bodies_in_hitbox := {}

func attack(attack_dir):
	print("Attack in direction", attack_dir)

func _on_hitbox_body_entered(body: Node2D) -> void:
	bodies_in_hitbox.set(body.get_instance_id(),  body)
	print("Body entered sword area", body.get_instance_id())


func _on_hitbox_body_exited(body: Node2D) -> void:
	bodies_in_hitbox.erase(body.get_instance_id())
	print("Body left sword area", body.get_instance_id())
