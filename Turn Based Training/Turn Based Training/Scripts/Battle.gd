extends Control
export(Resource) var enemy = null
signal textbox_closed
onready var healed_gif = $healed
var poison_time = 0
var slow_time = 0
var str_time = 0
var current_player_health = 8
var current_enemy_health = 8
var current_enemy_hitrate = 8
var is_defending = false
var is_poisoned = false
var is_slowed = false
var is_str = false
func _ready():
	# Setar o HP do Inimigo e as Texturas
	set_health($EnemyCont/ProgressBar, enemy.health, enemy.health)
	set_health($PlayerPanel/PlayerData/ProgressBar, State.current_health, State.max_health)
	$EnemyCont/Enemy.texture = enemy.texture
	
	current_enemy_hitrate = enemy.hit_rate
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
	if event.is_action_pressed("ui_accept") and $TextBox.visible:
		yield(get_tree().create_timer(0.50), "timeout")
		$TextBox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$TextBox.show()
	$TextBox/Label.text = text


func enemy_turn():
	display_text("Turno do %s" % enemy.name)
	yield(self,"textbox_closed")
	display_text("%s lhe ataca com suas garras afiadas!" % enemy.name.to_upper())
	yield(self, "textbox_closed")
	slow_pot()
	$AnimationPlayer.play("Angry")
	yield($AnimationPlayer, "animation_finished")
	if current_enemy_hitrate >= randi()%101:
		if is_defending:
			is_defending = false
			$AnimationPlayer.play("MiniShake")
			yield($AnimationPlayer, "animation_finished")
			display_text("Voce bloqueia grande parte do ataque, recebendo apenas \n %d de dano" % (enemy.damage/4))
			yield(self, "textbox_closed")
			current_player_health = max(0, current_player_health - (enemy.damage/4))
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
			poison()
			if current_player_health == 0:
				display_text("Que pena!, voce foi derrotado!")
				yield(self, "textbox_closed")
				yield(get_tree().create_timer(0.50), "timeout")
				get_tree().quit()
			$PlayerPanel/Actions.show()
		
		else:
			current_player_health = max(0, current_player_health - enemy.damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
			$AnimationPlayer.play("Shake")
			yield($AnimationPlayer, "animation_finished")
			display_text("Lhe arranhando e causando %d de dano" % enemy.damage )
			yield(self, "textbox_closed")
			yield(get_tree().create_timer(0.10), "timeout")
			poison()
			if current_player_health == 0:
				display_text("Que pena!, voce foi derrotado!")
				yield(self, "textbox_closed")
				yield(get_tree().create_timer(0.50), "timeout")
				get_tree().quit()
			$PlayerPanel/Actions.show()

	else:
			display_text("O inimigo errou o ataque" )
			yield(self, "textbox_closed")
			poison()
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
	$PlayerPanel/ActionSelect.hide()
	$PlayerPanel/Potions.hide()
	display_text("Voce atira com seu estilingue na criatura!")
	yield(self, "textbox_closed")
	if State.hit_rate >= randi()%100:
		if is_str:
			$AnimationPlayer.play("AttackBuff")
			yield($AnimationPlayer, "animation_finished")
			display_text("Voce ainda esta enfurecido!")
			yield(self, "textbox_closed")
			$AnimationPlayer.play("enemy_damaged")
			yield($AnimationPlayer, "animation_finished")
			current_enemy_health = max(0, current_enemy_health - (State.damage*2))
			set_health($EnemyCont/ProgressBar, current_enemy_health, enemy.health)
			display_text("Voce machucou a criatura e tirou um total de %d de HP" % (State.damage*2))
			yield(self, "textbox_closed")
			str_time = str_time+1
			if str_time == 2 :
				display_text("Voce relaxou")
				yield(self, "textbox_closed")
				is_str = false
		else:
			$AnimationPlayer.play("enemy_damaged")
			yield($AnimationPlayer, "animation_finished")
			current_enemy_health = max(0, current_enemy_health - State.damage)
			set_health($EnemyCont/ProgressBar, current_enemy_health, enemy.health)
			display_text("Voce machucou a criatura e tirou um total de %d de HP" % State.damage )
			yield(self, "textbox_closed")
	else:
			display_text("Você infelizmente errou o golpe")
			yield(self, "textbox_closed")
	if current_enemy_health == 0:
		$Poisoned.hide()
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
	$PlayerPanel/Actions.hide()
	$PlayerPanel/ActionSelect.show()
	


func _on_Return_pressed():
	$PlayerPanel/ActionSelect.hide()
	$PlayerPanel/Actions.show()
	


func _on_Potion_pressed():
	$PlayerPanel/Potions.hide()
	is_poisoned = true
	poison_time = 0
	display_text( "Voce arremessa a pocao de veneno em %s!" % enemy.name.to_upper())
	yield(self, "textbox_closed")
	$AnimationPlayer.play("Poisoned")
	yield($AnimationPlayer, "animation_finished")
	display_text( "O Alvo foi envenenado!")
	yield(self, "textbox_closed")
	$Poisoned.show()
	enemy_turn()
	
	
func poison():
	if is_poisoned:
		$AnimationPlayer.play("Poisoned")
		yield($AnimationPlayer, "animation_finished")
		display_text("%s esta envenenado!" % enemy.name.to_upper())
		yield(self, "textbox_closed")
		current_enemy_health = max(0, current_enemy_health - (enemy.health*0.2))
		set_health($EnemyCont/ProgressBar, current_enemy_health, enemy.health)
		poison_time = poison_time + 1
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
		if poison_time == 2:
			display_text("%s nao esta mais envenenado!" % enemy.name.to_upper())
			yield(self, "textbox_closed")
			$Poisoned.hide()
			is_poisoned = false


func health_pot():
	$PlayerPanel/Potions.hide()
	healed_gif.show()
	healed_gif.play("Healed")
	yield($healed, "animation_finished")
	healed_gif.hide()
	display_text("Você bebe um pocao de vida e regenera %d de vida" % (State.max_health*0.60))
	yield(self, "textbox_closed")
	current_player_health = min(State.max_health, current_player_health + State.max_health*0.60)
	set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
	enemy_turn()
	
	
func slow_pot():
	if is_slowed:
		display_text("A criatura esta cega")
		yield(self, "textbox_closed")
		$AnimationPlayer.play("Slowed")
		yield($AnimationPlayer, "animation_finished")
		current_enemy_hitrate = current_enemy_hitrate*0.4
		slow_time = slow_time + 1
		if slow_time == 2:
			current_enemy_hitrate = enemy.hit_rate
			display_text("A criatura nao esta mais cega")
			yield(self, "textbox_closed")
			$Blinded.hide()
			is_slowed = false

		
func _on_Potion2_pressed():
	health_pot()


func _on_Potions_pressed():
	$PlayerPanel/ActionSelect.hide()
	$PlayerPanel/Potions.show()


func _on_Return2_pressed():
	$PlayerPanel/Potions.hide()
	$PlayerPanel/ActionSelect.show()


func _on_Potion3_pressed():
	$PlayerPanel/Potions.hide()
	$AnimationPlayer.play("Slowed")
	yield($AnimationPlayer, "animation_finished")
	display_text("Você cegou %s!" % enemy.name.to_upper())
	yield(self, "textbox_closed")
	is_slowed = true
	slow_time = 0
	$Blinded.show()
	enemy_turn()


func _on_Potion4_pressed():
	$PlayerPanel/Potions.hide()
	$AnimationPlayer.play("AttackBuff")
	yield($AnimationPlayer, "animation_finished")
	display_text("Voce bebe a pocao da Ira e agora esta enfurecido!")
	yield(self, "textbox_closed")
	display_text("O Seu ataque aumentou!")
	is_str = true
	str_time = 0
	enemy_turn()
