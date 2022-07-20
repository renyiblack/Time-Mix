extends Control
func action_attack():
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
		get_tree().change_scene("res://Cenas/tutorial.tscn")
	else:
		enemy_turn()
