extends StaticBody2D

@onready var interactable: Area2D = $Interactable
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_get: AudioStreamPlayer2D = $sfx_get

func _ready() -> void:
	$AnimatedSprite2D.play("VHS_idle")
	interactable.interact = _on_interact
	if Global.collectedItems.has(global_position):
		queue_free() #free the item becouse already has been collected
	else:
		Global.items.append(global_position)
	

func _on_interact():
	Global.score += 1
	sfx_get.play()
	await sfx_get.finished
	print("you got a tape!")
	Global.collectedItems.append(global_position)
	Global.items.erase(global_position)
	queue_free()
