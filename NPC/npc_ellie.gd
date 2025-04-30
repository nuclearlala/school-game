extends CharacterBody2D

var player_in_area = false

func _physics_process(_delta):
	$AnimatedSprite2D.play("Ellie_Idle")
	if player_in_area:
		if Input.is_action_just_pressed("ui_accept"):
			run_dialogue("Ellie Dialog")

func _on_chat_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true


func _on_chat_detection_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true

func run_dialogue(dialogue_string):
	Dialogic.start(dialogue_string)
