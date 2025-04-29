extends StaticBody2D

@onready var interactable: Area2D = $Interactable
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_get: AudioStreamPlayer2D = $sfx_get
@onready var u_didit: Sprite2D = $UDidit
@onready var needmoretapes: Sprite2D = $Needmoretapes
@onready var finished: AudioStreamPlayer2D = $finished


func _ready() -> void:
	$AnimatedSprite2D.play("return_Shine")
	interactable.interact = _on_interact
	u_didit.visible= false
	needmoretapes.visible= false

func _on_interact():
	if Global.score < 4:
		sfx_get.play()
		needmoretapes.visible= true
		print("find more tapes!!!")
	elif Global.score <= 4:
		print("you did it!!")
		finished.play()
		Global.score = 0
		u_didit.visible= true
