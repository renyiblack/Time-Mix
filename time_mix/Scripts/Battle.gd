extends Control
export(Resource) var enemy = null
signal textbox_closed
onready var healed_gif = $healed
onready var actbutton = $PlayerPanel/Actions/Action
onready var atkbutton = $PlayerPanel/ActionSelect/Attack
onready var potbutton = $PlayerPanel/Potions/Potion2
var poison_time = 0
var poison_time2 = 0
var slow_time = 0
var str_time = 0
var res_time = 0
var current_player_health = 8.0
var current_enemy_health = 8.0
var current_enemy_hitrate = 8.0
var current_player_defrate = 8.0
var is_resisting = false
var is_defending = false
var is_poisoned = false
var play_poisoned = false
var is_slowed = false
var is_str = false
var enemy_action = 0


func _ready():
# Setar o HP do Inimigo e as Texturas
	set_health($EnemyCont/ProgressBar, enemy.health, enemy.health)
	set_health($PlayerPanel/PlayerData/ProgressBar, State.current_health, State.max_health)
	$EnemyCont/Enemy.texture = enemy.texture
	current_player_defrate = State.def_rate
	current_enemy_hitrate = enemy.hit_rate
	current_player_health = State.current_health
	current_enemy_health = enemy.health
		
	$TextBox.hide()
	$PlayerPanel/Actions.hide()
	display_text("Um %s selvagem apareceu o que devo fazer?" % enemy.name.to_upper())
	yield(self, "textbox_closed")
	$PlayerPanel/Actions.show()
	actbutton.grab_focus()
	
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
	if enemy.enemy_power_up:
		charged_attack()
	else:
		enemy_action = choose(enemy.skills)
		match enemy_action:
			0:
				claw_attack()
			1:
				bite_attack()
			2:
				poison_strike()
			3:
				PowerUp()
# ACTIONS SELECTION


func _on_Run_pressed():
	$PlayerPanel/Actions.hide()
	$ButtonSfx.play()
	display_text("Voce conseguiu escapar!")
	yield(self, "textbox_closed")
	yield(get_tree().create_timer(0.50), "timeout")
	get_tree().change_scene("res://Cenas/tutorial.tscn")


func _on_Attack_pressed():
	$PlayerPanel/ActionSelect.hide()
	$ButtonSfx.play()
	$PlayerPanel/Potions.hide()
	display_text("Voce atira com seu estilingue na criatura!")
	yield(self, "textbox_closed")
	if State.hit_rate >= randi()%100:
		if is_str:
			$AnimationPlayer.play("AttackBuff")
			yield($AnimationPlayer, "animation_finished")
			display_text("Voce ainda esta mais forte!")
			yield(self, "textbox_closed")
			$EnhancedStrike.play()
			$AnimationPlayer.play("enemy_damaged")
			yield($AnimationPlayer, "animation_finished")
			current_enemy_health = max(0, current_enemy_health - (State.damage*2))
			set_health($EnemyCont/ProgressBar, current_enemy_health, enemy.health)
			display_text("Voce machucou a criatura e tirou um total de %d de HP" % (State.damage*2))
			yield(self, "textbox_closed")
			str_time = str_time+1
			if str_time == 2 :
				display_text("Voce se acalma")
				yield(self, "textbox_closed")
				is_str = false
		else:
			$Strike.play()
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
		$BattleTheme.stop()
		$YouWin.play()
		display_text("%s foi derrotado, e fugiu" % enemy.name)
		yield(self, "textbox_closed")
		display_text("Bom trabalho!")
		yield(self, "textbox_closed")
		yield(get_tree().create_timer(0.25), "timeout")
		get_tree().change_scene("res://Cenas/tutorial.tscn")
	else:
		playpoison()
		enemy_turn()

	


func _on_Guard_pressed():
	$PlayerPanel/Actions.hide()
	$ButtonSfx.play()
	is_defending = true
	display_text("Voce se prepara para se defender do ataque")
	yield(self, "textbox_closed")
	playpoison()
	yield(get_tree().create_timer(0.25), "timeout")
	enemy_turn()


func _on_Action_pressed():
	$PlayerPanel/Actions.hide()
	$ButtonSfx.play()
	$PlayerPanel/ActionSelect.show()
	atkbutton.grab_focus()
	


func _on_Return_pressed():
	$PlayerPanel/ActionSelect.hide()
	$ButtonSfx.play()
	$PlayerPanel/Actions.show()
	actbutton.grab_focus()
	


func _on_Potion_pressed():
	$PlayerPanel/Potions.hide()
	$ButtonSfx.play()
	is_poisoned = true
	poison_time = 0
	display_text( "Voce arremessa a pocao de veneno em %s!" % enemy.name.to_upper())
	yield(self, "textbox_closed")
	$PoisonPotion.play()
	$AnimationPlayer.play("Poisoned")
	yield($AnimationPlayer, "animation_finished")
	display_text( "O Alvo foi envenenado!")
	yield(self, "textbox_closed")
	$Poisoned.show()
	enemy_turn()
	
	
func poison():
		
	if is_poisoned:
		display_text("%s esta envenenado!" % enemy.name.to_upper())
		yield(self, "textbox_closed")
		$AnimationPlayer.play("Poisoned")
		yield($AnimationPlayer, "animation_finished")
		$PoisonEffect.play()
		current_enemy_health = max(0, current_enemy_health - (enemy.health*0.2))
		set_health($EnemyCont/ProgressBar, current_enemy_health, enemy.health)
		poison_time = poison_time + 1
		if current_enemy_health == 0:
			$EnemyCont/ProgressBar.hide()
			$Poisoned.hide()
			$AnimationPlayer.play("EnemyDefeated")
			yield($AnimationPlayer, "animation_finished")
			$BattleTheme.stop()
			$YouWin.play()
			display_text("%s foi derrotado, e fugiu" % enemy.name)
			yield(self, "textbox_closed")
			display_text("Bom trabalho!")
			yield(self, "textbox_closed")
			yield(get_tree().create_timer(0.25), "timeout")
			get_tree().change_scene("res://Cenas/tutorial.tscn")
		if poison_time == 2:
			display_text("%s nao esta mais envenenado!" % enemy.name.to_upper())
			yield(self, "textbox_closed")
			$Poisoned.hide()
			is_poisoned = false
func playpoison():
	if play_poisoned:
		current_player_health = max(0, current_player_health - State.max_health * 0.2)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
		$PoisonEffect.play()
		$AnimationPlayer.play("PlayerPoison")
		yield($AnimationPlayer, "animation_finished")
		display_text("Voce esta envenenado!")
		yield(self, "textbox_closed")
		display_text("Voce recebeu %d de dano" % (State.max_health * 0.2))
		yield(self, "textbox_closed")
		poison_time2 = poison_time2 + 1
		if current_player_health == 0:
				display_text("Que pena!, voce foi derrotado!")
				yield(self, "textbox_closed")
				yield(get_tree().create_timer(0.50), "timeout")
				get_tree().change_scene("res://Cenas/Menu.tscn")
		if poison_time == 2:
			display_text("Voce nao esta mais envenenado!")
			yield(self, "textbox_closed")
			$Poisoned2.hide()
			play_poisoned = false

func health_pot():
	$PlayerPanel/Potions.hide()
	healed_gif.show()
	healed_gif.play("Healed")
	$Heal.play(1.2)
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
		current_enemy_hitrate = current_enemy_hitrate-60
		slow_time = slow_time + 1
		if slow_time == 2:
			current_enemy_hitrate = enemy.hit_rate
			display_text("A criatura nao esta mais cega")
			yield(self, "textbox_closed")
			$Blinded.hide()
			is_slowed = false
			
			
func defend_pot():
	if is_resisting:
		current_player_defrate = 2
		display_text("Voce esta mais resistente!")
		yield(self, "textbox_closed")
		$AnimationPlayer.play("Defending")
		yield($AnimationPlayer, "animation_finished")
		res_time = res_time + 1
		if res_time == 3:
			display_text("Sua resistencia acabou!")
			yield(self, "textbox_closed")
			current_player_defrate = 1
			is_resisting = false
	else:
		pass
		
		
		

		
func _on_Potion2_pressed():
	health_pot()
	$ButtonSfx.play()

func _on_Potions_pressed():
	$PlayerPanel/ActionSelect.hide()
	$ButtonSfx.play()
	$PlayerPanel/Potions.show()
	potbutton.grab_focus()


func _on_Return2_pressed():
	$PlayerPanel/Potions.hide()
	$ButtonSfx.play()
	$PlayerPanel/ActionSelect.show()
	atkbutton.grab_focus()


func _on_Potion3_pressed():
	$PlayerPanel/Potions.hide()
	$ButtonSfx.play()
	$AnimationPlayer.play("Slowed")
	$Blindpot.play()
	yield($AnimationPlayer, "animation_finished")
	display_text("Você cegou %s!" % enemy.name.to_upper())
	yield(self, "textbox_closed")
	is_slowed = true
	slow_time = 0
	$Blinded.show()
	enemy_turn()


func _on_Potion4_pressed():
	$PlayerPanel/Potions.hide()
	$ButtonSfx.play()
	$PowerUp.play()
	$AnimationPlayer.play("AttackBuff")
	yield($AnimationPlayer, "animation_finished")
	display_text("Voce bebe a pocao da Ira e se sente mais forte!")
	yield(self, "textbox_closed")
	display_text("O Seu ataque aumentou!")
	is_str = true
	str_time = 0
	enemy_turn()


func _on_Potion5_pressed():
	$PlayerPanel/Potions.hide()
	$ButtonSfx.play()
	display_text("Sua pele enrijece!")
	yield(self, "textbox_closed")
	$AnimationPlayer.play("Defending")
	$DefensePotion.play()
	yield($AnimationPlayer, "animation_finished")
	display_text("Agora voce esta mais resistente!")
	yield(self, "textbox_closed")
	is_resisting = true
	res_time = 0
	enemy_turn()



#ENEMY MOVESET

func poison_strike():
	display_text("Turno do %s" % enemy.name)
	yield(self,"textbox_closed")
	display_text("%s lhe ataca com sua cauda venenosa" % enemy.name)
	yield(self,"textbox_closed")
	defend_pot()
	slow_pot()
	if current_enemy_hitrate >= randi()%101:
			if is_defending:
				is_defending = false
				$EnemyStrike.play()
				$AnimationPlayer.play("MiniShake")
				yield($AnimationPlayer, "animation_finished")
				display_text("Voce bloqueia grande parte do ataque, recebendo apenas \n %d de dano" % (((enemy.damage*1.25)/4)/current_player_defrate))
				yield(self, "textbox_closed")
				current_player_health = max(0, current_player_health - (((enemy.damage*1.25)/4)/current_player_defrate))
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
				poison()
				if current_player_health == 0:
					display_text("Que pena!, voce foi derrotado!")
					yield(self, "textbox_closed")
					yield(get_tree().create_timer(0.50), "timeout")
					get_tree().change_scene("res://Cenas/Menu.tscn")
				$PlayerPanel/Actions.show()
				actbutton.grab_focus()
		
			else:
				$PoisonStrike.play()
				$AnimationPlayer.play("Shake")
				yield($AnimationPlayer, "animation_finished")
				play_poisoned = true
				display_text("Lhe arranhando e causando %d de dano" % (enemy.damage / current_player_defrate) )
				yield(self, "textbox_closed")
				display_text("Voce foi envenenado!")
				yield(self, "textbox_closed")
				$PlayerPanel/Poisoned2.show()
				poison_time2 = 0
				yield(get_tree().create_timer(0.10), "timeout")
				current_player_health = max(0, current_player_health - enemy.damage/current_player_defrate)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
				$PlayerPanel/Actions.show()
				actbutton.grab_focus()
			if current_player_health == 0:
				display_text("Que pena!, voce foi derrotado!")
				yield(self, "textbox_closed")
				yield(get_tree().create_timer(0.50), "timeout")
				get_tree().change_scene("res://Cenas/Menu.tscn")

	else:
			display_text("O inimigo errou o ataque" )
			yield(self, "textbox_closed")
			poison()
			$PlayerPanel/Actions.show()
			actbutton.grab_focus()
	

func PowerUp():
	display_text("Turno do %s" % enemy.name)
	yield(self,"textbox_closed")
	$PowerUp.play()
	display_text("O %s se prepara para dar um ataque poderoso" % enemy.name)
	yield(self,"textbox_closed")
	enemy.enemy_power_up = true
	poison()
	$PlayerPanel/Actions.show()
	actbutton.grab_focus()


func bite_attack():
	display_text("Turno do %s" % enemy.name)
	yield(self,"textbox_closed")
	display_text("%s tenta lhe dar uma mordida!" % enemy.name)
	yield(self,"textbox_closed")
	defend_pot()
	slow_pot()
	if current_enemy_hitrate >= randi()%101:
			if is_defending:
				is_defending = false
				$EnemyStrike.play()
				$AnimationPlayer.play("MiniShake")
				yield($AnimationPlayer, "animation_finished")
				display_text("Voce bloqueia grande parte do ataque, recebendo apenas \n %d de dano" % (((enemy.damage)/4)/current_player_defrate))
				yield(self, "textbox_closed")
				current_player_health = max(0, current_player_health - (((enemy.damage)/4)/current_player_defrate))
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
				poison()
				if current_player_health == 0:
					display_text("Que pena!, voce foi derrotado!")
					yield(self, "textbox_closed")
					yield(get_tree().create_timer(0.50), "timeout")
					get_tree().change_scene("res://Cenas/Menu.tscn")
				$PlayerPanel/Actions.show()
				actbutton.grab_focus()
		
			else:
				current_player_health = max(0, current_player_health - enemy.damage/current_player_defrate)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
				$Bite.play()
				$AnimationPlayer.play("Shake")
				yield($AnimationPlayer, "animation_finished")
				display_text("Que lhe perfura e causa %d de dano" % (enemy.damage / current_player_defrate) )
				yield(self, "textbox_closed")
				yield(get_tree().create_timer(0.10), "timeout")
				poison()
				$PlayerPanel/Actions.show()
				actbutton.grab_focus()
			if current_player_health == 0:
				display_text("Que pena!, voce foi derrotado!")
				yield(self, "textbox_closed")
				yield(get_tree().create_timer(0.50), "timeout")
				get_tree().change_scene("res://Cenas/Menu.tscn")
	else:
			display_text("O inimigo errou o ataque" )
			yield(self, "textbox_closed")
			poison()
			$PlayerPanel/Actions.show()
			actbutton.grab_focus()
			
func claw_attack():
	display_text("Turno do %s" % enemy.name)
	yield(self,"textbox_closed")
	display_text("%s lhe ataca com suas garras afiadas!" % enemy.name.to_upper())
	yield(self, "textbox_closed")
	slow_pot()
	$AnimationPlayer.play("Angry")
	yield($AnimationPlayer, "animation_finished")
	defend_pot()
	if current_enemy_hitrate >= randi()%101:
		if is_defending:
			is_defending = false
			$EnemyStrike.play()
			$AnimationPlayer.play("MiniShake")
			yield($AnimationPlayer, "animation_finished")
			display_text("Voce bloqueia grande parte do ataque, recebendo apenas \n %d de dano" % ((enemy.damage/4)/current_player_defrate))
			yield(self, "textbox_closed")
			current_player_health = max(0, current_player_health - (enemy.damage/4)/current_player_defrate)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
			poison()
			if current_player_health == 0:
				display_text("Que pena!, voce foi derrotado!")
				yield(self, "textbox_closed")
				yield(get_tree().create_timer(0.50), "timeout")
				get_tree().change_scene("res://Cenas/Menu.tscn")
			$PlayerPanel/Actions.show()
			actbutton.grab_focus()
		
		else:
			current_player_health = max(0, current_player_health - enemy.damage/current_player_defrate)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
			$EnemyClaw.play()
			$AnimationPlayer.play("Shake")
			yield($AnimationPlayer, "animation_finished")
			display_text("Lhe arranhando e causando %d de dano" % (enemy.damage / current_player_defrate) )
			yield(self, "textbox_closed")
			yield(get_tree().create_timer(0.10), "timeout")
			poison()
			if current_player_health == 0:
				display_text("Que pena!, voce foi derrotado!")
				yield(self, "textbox_closed")
				yield(get_tree().create_timer(0.50), "timeout")
				get_tree().change_scene("res://Cenas/Menu.tscn")
			$PlayerPanel/Actions.show()
			actbutton.grab_focus()

	else:
			display_text("O inimigo errou o ataque" )
			yield(self, "textbox_closed")
			poison()
			$PlayerPanel/Actions.show()
			actbutton.grab_focus()
func charged_attack():
	display_text("Turno do %s" % enemy.name)
	yield(self,"textbox_closed")
	display_text("%s prepara para dar um ataque carregado!" % enemy.name.to_upper())
	yield(self, "textbox_closed")
	enemy.enemy_power_up = false
	slow_pot()
	$AnimationPlayer.play("Angry")
	yield($AnimationPlayer, "animation_finished")
	defend_pot()
	if current_enemy_hitrate >= randi()%101:
		if is_defending:
			is_defending = false
			$EnemyStrike.play()
			$AnimationPlayer.play("MiniShake")
			yield($AnimationPlayer, "animation_finished")
			display_text("Voce bloqueia grande parte do ataque, recebendo apenas \n %d de dano" % ((enemy.damage*2/4)/current_player_defrate))
			yield(self, "textbox_closed")
			current_player_health = max(0, current_player_health - (enemy.damage*2/4)/current_player_defrate)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
			poison()
			if current_player_health == 0:
				display_text("Que pena!, voce foi derrotado!")
				yield(self, "textbox_closed")
				yield(get_tree().create_timer(0.50), "timeout")
				get_tree().change_scene("res://Cenas/Menu.tscn")
			$PlayerPanel/Actions.show()
			actbutton.grab_focus()
		
		else:
			current_player_health = max(0, current_player_health - enemy.damage*2/current_player_defrate)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
			$EnhancedStrike.play()
			$AnimationPlayer.play("Shake")
			yield($AnimationPlayer, "animation_finished")
			display_text("Lhe arranhando e causando %d de dano" % (enemy.damage*2 / current_player_defrate) )
			yield(self, "textbox_closed")
			yield(get_tree().create_timer(0.10), "timeout")
			poison()
			if current_player_health == 0:
				display_text("Que pena!, voce foi derrotado!")
				yield(self, "textbox_closed")
				yield(get_tree().create_timer(0.50), "timeout")
				get_tree().change_scene("res://Cenas/Menu.tscn")
			$PlayerPanel/Actions.show()
			actbutton.grab_focus()

	else:
			display_text("O inimigo errou o ataque" )
			yield(self, "textbox_closed")
			poison()
			$PlayerPanel/Actions.show()
			actbutton.grab_focus()

func choose(array):
	return array[randi() % array.size()]
