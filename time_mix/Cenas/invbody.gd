extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if(Input.is_action_just_pressed("ui_inventory")):
		get_tree().change_scene("res://Cenas/tutorial.tscn")
