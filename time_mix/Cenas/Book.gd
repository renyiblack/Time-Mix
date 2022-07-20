extends Control

onready var anibook = $CanvasLayer/Book
var tracker = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_LEFT_pressed():
	$CanvasLayer/Page1/LEFT.hide()
	$CanvasLayer/Page1.hide()
	anibook.show()
	anibook.play("BookLeft")
	yield(anibook, "animation_finished")
	anibook.hide()
	$CanvasLayer/Page2.show()
	$CanvasLayer/Page2/RIGHT.show()

func _on_RIGHT_pressed():
	$CanvasLayer/Page2/RIGHT.hide()
	$CanvasLayer/Page2.hide()
	anibook.show()
	anibook.play("BookRight")
	yield(anibook, "animation_finished")
	anibook.hide()
	$CanvasLayer/Page1.show()
	$CanvasLayer/Page1/LEFT.show()


func _on_Exit_pressed():
	get_tree().change_scene("res://Cenas/tutorial.tscn")
