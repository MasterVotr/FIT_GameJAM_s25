extends Node


var pl_stat_vitality := 1.0
var pl_stat_strength := 1.0
var pl_stat_agility := 1.0

var lvl_collected_shards := 0
var lvl_shard_count := 10
var lvl_sacrifice_counter := 0
var lvl_random_spawn_seed := 0 		## Allowed values: 0, 1, 2, 3

var glob_high_score := 0
var glob_score := 0
var glob_lvl_score := 0

var player_near_altar := false
var sacrifice_score_penalty := 10
