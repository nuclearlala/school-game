extends CharacterBody2D

var speed = 100
var player_chase = false
var player = null
var idle = true

var health = 30
var player_inattack_zone = false
var in_death_anim = false
var can_take_damage = true
var dead = false

func _physics_process(_delta):
	
	if not in_death_anim:
		if player_chase:
			position += (player.position - position)/speed
			
			if player_inattack_zone:
				$AnimatedSprite2D.play("rat_attack")
			else:
				$AnimatedSprite2D.play("rat_walk")
			
			if(player.position.x - position.x) < 0:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true
		else: 
			$AnimatedSprite2D.play("rat_walk")
		move_and_slide()
		deal_with_damage()
		update_health()
		
func _on_detection_area_body_entered(_body: Node2D) -> void:
	player = _body
	player_chase = true


func _on_detection_area_body_exited(_body: Node2D) -> void:
	player = null
	player_chase = false

func enemy():
	pass


func _on_enemy_hitbox_body_entered(_body: Node2D) -> void:
	if _body.has_method("player"):
		player_inattack_zone = true

func _on_enemy_hitbox_body_exited(_body: Node2D) -> void:
	if _body.has_method("player"):
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone and Global.player_current_attack == true:
		if can_take_damage == true:
			health = health - 10
			$take_damage_cooldown.start()
			can_take_damage = false
			print("rat health = ", health)
			if health <= 0:
				in_death_anim = true
				$AnimatedSprite2D.play("rat_explode")
				await get_tree().create_timer(1.0).timeout
				self.queue_free()

func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true


func update_health():
	var healthbar = $HealthBar
	
	healthbar.value = health
	
	if health >= 30:
		healthbar.visible = false
	
	else:
		healthbar.visible = true
	 
