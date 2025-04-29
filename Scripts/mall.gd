extends Node2D

func _ready():
	if SceneManager.player:
		add_child(SceneManagerd.player)
