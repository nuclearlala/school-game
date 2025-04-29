extends Area2D

@export var text_key: String = ""
@onready var sfx_interact: AudioStreamPlayer2D = $sfx_interact

var area_active: bool = false

func _input(event):
	if area_active and event.is_action_pressed("ui_accept"):
		sfx_interact.play()
		SignalBus.emit_signal("display_dialog", text_key)
		
func _on_DialogArea_area_entered(_area):
	area_active = true
	
func _on_DialogArea_area_exited(_area):
	area_active = false
