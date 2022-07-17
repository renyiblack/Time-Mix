extends "res://Scripts/Battle.gd"
class_name MoveSet
func poison_strike():
	display_text("Turno do %s" % enemy.name)
	yield(self,"textbox_closed")
	display_text("O %s realiza um cuspe acido em sua direcao" % enemy.name)
	yield(self,"textbox_closed")
	if current_enemy_hitrate >= randi()%101:
			if is_defending:
				is_defending = false
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
					get_tree().quit()
				$PlayerPanel/Actions.show()
		
			else:
				current_player_health = max(0, current_player_health - enemy.damage/current_player_defrate)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
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
				get_tree().quit()
				$PlayerPanel/Actions.show()

	else:
			display_text("O inimigo errou o ataque" )
			yield(self, "textbox_closed")
			poison()
			$PlayerPanel/Actions.show()
	

func PowerUp():
	display_text("Turno do %s" % enemy.name)
	yield(self,"textbox_closed")
	display_text("O %s se prepara para dar um ataque poderoso" % enemy.name)
	yield(self,"textbox_closed")
	enemy.enemy_power_up = true
	$PlayerPanel/Actions.show()


func bite_attack():
	display_text("Turno do %s" % enemy.name)
	yield(self,"textbox_closed")
	display_text("%s tenta lhe dar uma mordida!" % enemy.name)
	yield(self,"textbox_closed")
	if current_enemy_hitrate >= randi()%101:
			if is_defending:
				is_defending = false
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
					get_tree().quit()
				$PlayerPanel/Actions.show()
		
			else:
				current_player_health = max(0, current_player_health - enemy.damage/current_player_defrate)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
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
				get_tree().quit()
				$PlayerPanel/Actions.show()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
