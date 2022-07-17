extends KinematicBody2D

onready var player = get_node("/root/tutorial/TileMap/player")
onready var camera = player.get_node("Camera2D")

var velocity = Vector2.ZERO
const max_speed = 250

func _ready():
	camera.current = true

func _physics_process(delta):
	var vector = Vector2.ZERO
	vector.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	vector.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	vector = vector.normalized()
	if vector!=Vector2.ZERO:
		velocity=vector*max_speed
	else:
		velocity = Vector2.ZERO
		
	velocity = move_and_slide(velocity)
