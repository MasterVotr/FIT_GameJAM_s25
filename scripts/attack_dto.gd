extends Node

var damage := 0
var knockback := 0
var stun_duration := 0.0
var armorpiercing := 0.0 # injury = (damage - (armor * (1.0 - armorpiercing)))
var bleed := false
var attack_dir := Vector2(0.0, 0.0)
