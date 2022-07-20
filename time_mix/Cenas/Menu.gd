extends Node2D
onready var ngbutton = $CanvasLayer/NEWGAME
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("TextFade")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("WhiteTextFade")
	yield($AnimationPlayer, "animation_finished")
	ngbutton.grab_focus()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EXIT_pressed():
	yield(get_tree().create_timer(0.50), "timeout")
	get_tree().quit()


func _on_NEWGAME_pressed():
	get_tree().change_scene("res://Cenas/tutorial.tscn")


func _on_SoundOn_pressed():
	$CanvasLayer/SoundOn.hide()
	$MenuSFX.stop()
	$CanvasLayer/SoundOff.show()
	ngbutton.grab_focus()


func _on_SoundOff_pressed():
	$CanvasLayer/SoundOff.hide()
	$MenuSFX.play()
	$CanvasLayer/SoundOn.show()
	ngbutton.grab_focus()
