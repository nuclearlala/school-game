extends CharacterBody2D

class_name Player

var enemy_inattack_range = false
var enemy_cooldown = true
var health = 100
var player_alive = true
var attack_ip = false
var speed = 300
var current_dir= "none"


@onready var healthbar = $CanvasLayer/HealthBar
@onready var sfx_attack: AudioStreamPlayer2D = $sfx_attack
@onready var sfx_bite: AudioStreamPlayer2D = $sfx_bite



func _ready():
	$AnimatedSprite2D.play("front_idle")
	NavigationManager.on_trigger_player_spawn.connect(_on_spawn)
	
func _on_spawn(position: Vector2, direction: String):
	global_position = position
	$AnimatedSprite2D.play("move_" + direction)
	$AnimatedSprite2D.stop()
	
func _physics_process(_delta):
	player_movement(_delta)
	enemy_attack()
	attack()
	update_health()
	
	if health <= 0:
		player_alive = false
		health = 0
		get_tree().change_scene_to_file("res://Scenes/gameover.tscn")
	
func player_movement(_delta):
	if attack_ip == false:
		if Input.is_action_pressed("ui_right"):
			current_dir= "right"
			play_anim(1)
			velocity.x = speed
			velocity.y = 0
		elif Input.is_action_pressed("ui_left"):
			play_anim(1)
			current_dir= "left"
			velocity.x = -speed
			velocity.y = 0
		elif Input.is_action_pressed("ui_down"):
			play_anim(1)
			current_dir= "down"
			velocity.y = speed
			velocity.x = 0
		elif Input.is_action_pressed("ui_up"):
			play_anim(1)
			current_dir= "up"
			velocity.y = -speed
			velocity.x = 0
		else:
			play_anim(0)
			velocity.x = 0
			velocity.y = 0
				
	move_and_slide()
			
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
		
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
			
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
		
	if dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_idle")
			
	if dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("back_idle")

func player():
	pass

func _on_player_hitbox_body_entered(_body):
	if _body.has_method("enemy"):
		enemy_inattack_range = true



func _on_player_hitbox_body_exited(_body):
	if _body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_cooldown:
		health = health - 15
		enemy_cooldown = false
		$attack_cooldown.start()
		$sfx_bite.play()
		print(health)


func _on_attack_cooldown_timeout() -> void:
	enemy_cooldown = true

func attack():
	var dir = current_dir
	if attack_ip == false:
		if Input.is_action_just_pressed("attack"):
			velocity.x = 0
			velocity.y = 0
			sfx_attack.play()
			Global.player_current_attack = true
			attack_ip = true
			if dir == "right":
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("side_attack")
				$deal_attack_timer.start()
			if dir == "left":
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("side_attack")
				$deal_attack_timer.start()
			if dir == "down":
				$AnimatedSprite2D.play("front_attack")
				$deal_attack_timer.start()
			if dir == "up":
				$AnimatedSprite2D.play("back_attack")
				$deal_attack_timer.start()
				

			move_and_slide()




func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_ip = false

func update_health():
	var healthbar = $CanvasLayer/HealthBar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = true

func _on_regen_timer_timeout() -> void:
	if health < 100:
		health = health + 20
		if health > 100:
			health = 100
	if health <= 0:
		health = 0
