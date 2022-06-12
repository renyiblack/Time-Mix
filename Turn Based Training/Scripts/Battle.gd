extends Control
export(Resource) var enemy = null
signal textbox_closed


var current_player_health = 8
var current_enemy_health = 8
var is_defending = false

func _ready():
	# Setar o HP do Inimigo e as Texturas
	set_health($EnemyCont/ProgressBar, enemy.health, enemy.health)
	set_health($PlayerPanel/PlayerData/ProgressBar, State.current_health, State.max_health)
	$EnemyCont/Enemy.texture = enemy.texture
	
	
	current_player_health = State.current_health
	current_enemy_health = enemy.health
	
	$TextBox.hide()
	$PlayerPanel/Actions.hide()
	display_text("Um %s selvagem apareceu o que devo fazer?" % enemy.name.to_upper())
	yield(self, "textbox_closed")
	$PlayerPanel/Actions.show()
	
	
func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health, max_health]
func _input(event):
	yield(get_tree().create_timer(0.10), "timeout")
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(BUTTON_LEFT) and $TextBox.visible:
		$TextBox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$TextBox.show()
	$TextBox/Label.text = text


func enemy_turn():
	display_text("%s lhe ataca com suas garras afiadas!" % enemy.name.to_upper())
	yield(get_tree().create_timer(0.25), "timeout")
	yield(self, "textbox_closed")
	$AnimationPlayer.play("Angry")
	yield($AnimationPlayer, "animation_finished")
	if enemy.hit_rate >= randi()%101:
	
		if is_defending:
			is_defending = false
			$AnimationPlayer.play("MiniShake")
			yield($AnimationPlayer, "animation_finished")
			display_text("Voce bloqueia grande parte do ataque, recebendo apenas \n %d de dano" % (enemy.damage/4))
			yield(self, "textbox_closed")
			current_player_health = max(0, current_player_health - (enemy.damage/4))
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
			yield(get_tree().create_timer(0.10), "timeout")
			$PlayerPanel/Actions.show()
		
		else:
			current_player_health = max(0, current_player_health - enemy.damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
			$AnimationPlayer.play("Shake")
			yield($AnimationPlayer, "animation_finished")
			display_text("Lhe arranhando e causando %d de dano" % enemy.damage )
			yield(self, "textbox_closed")
			yield(get_tree().create_timer(0.10), "timeout")
			$PlayerPanel/Actions.show()
	else:
			display_text("O inimigo errou o ataque" )
			yield(self, "textbox_closed")
			$PlayerPanel/Actions.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Run_pressed():
	$PlayerPanel/Actions.hide()
	display_text("Voce conseguiu escapar!")
	yield(self, "textbox_closed")
	yield(get_tree().create_timer(0.50), "timeout")
	get_tree().quit()


func _on_Attack_pressed():
	$PlayerPanel/Actions.hide()
	display_text("Voce atira com seu estilingue na criatura!")
	yield(self, "textbox_closed")
	if State.hit_rate >= randi()%101:
		$AnimationPlayer.play("enemy_damaged")
		yield($AnimationPlayer, "animation_finished")
		current_enemy_health = max(0, current_enemy_health - State.damage)
		set_health($EnemyCont/ProgressBar, current_enemy_health, enemy.health)
		display_text("Voce machucou a criatura e tirou um total de %d de HP" % State.damage )
		yield(self, "textbox_closed")
		yield(get_tree().create_timer(0.50), "timeout")
	else:
			display_text("Você infelizmente errou o golpe")
			yield(self, "textbox_closed")
	if current_enemy_health == 0:
		$EnemyCont/ProgressBar.hide()
		$AnimationPlayer.play("EnemyDefeated")
		yield($AnimationPlayer, "animation_finished")
		display_text("%s foi derrotado, e fugiu" % enemy.name)
		yield(self, "textbox_closed")
		display_text("Bom trabalho!")
		yield(self, "textbox_closed")
		yield(get_tree().create_timer(0.25), "timeout")
		get_tree().quit()
	else:
		enemy_turn()

	


func _on_Guard_pressed():
	$PlayerPanel/Actions.hide()
	is_defending = true
	display_text("Voce se prepara para se defender do ataque")
	yield(self, "textbox_closed")
	yield(get_tree().create_timer(0.25), "timeout")
	enemy_turn()


func _on_Action_pressed():
	$PlayerPanel/ActionSelect.show()
	
