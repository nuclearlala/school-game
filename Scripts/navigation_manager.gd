extends Node

const scene_menu = preload("res://Scenes/menu.tscn")
const scene_world = preload("res://Scenes/world.tscn")
const scene_mall = preload("res://Scenes/mall.tscn")
const scene_videostore = preload("res://Scenes/videostore.tscn")

signal on_trigger_player_spawn

var spawn_door_tag

func go_to_level(level_tag, destination_tag):
	var scene_to_load
	
	match level_tag:
		"menu":
			scene_to_load = scene_menu
		"world":
			scene_to_load = scene_world
		"mall":
			scene_to_load = scene_mall
		"videostore":
			scene_to_load = scene_videostore
			
	if scene_to_load != null:
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)
				
func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)
