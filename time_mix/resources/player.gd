extends KinematicBody2D

onready var player = get_node("/root/island/Ground/player")
onready var camera = player.get_node("Camera2D")
onready var compendium = get_node("/root/island/Ground/Compendium")
var battle = preload("res://Cenas/Battle.tscn").instance()

var velocity = Vector2.ZERO
const max_speed = 250
var just_spawned = true
var generate_mob = false
var plant_sprite

func _ready():
	camera.current = true
	position = State.player_location

func _physics_process(delta):
	var vector = Vector2.ZERO
	
	if(Input.is_action_just_pressed("ui_interact")):
		if(plant_sprite != null):
			var alpha = (plant_sprite as ColorRect).color.a
			if(alpha<1):
				# farming
				(plant_sprite as ColorRect).color.a+=0.1
			if(alpha>=1):
				# collected
				(plant_sprite as ColorRect).color.a=0
				
	
	vector.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	vector.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	vector = vector.normalized()
	
	
	if vector!=Vector2.ZERO:
		$AnimationPlayer.play("moving")
		spawn_mob()
		velocity=vector*max_speed
	else:
		velocity = Vector2.ZERO
		
	velocity = move_and_slide(velocity)

func spawn_mob():
	var rng = RandomNumberGenerator.new()
	if(just_spawned):
		generate_mob = false
		just_spawned = false

	if(generate_mob):
		rng.randomize()
		var number = rng.randi_range(0, 100)
		if(number>99):
			State.player_location = position
			get_tree().change_scene("res://Cenas/Battle.tscn")
			print("mob spawned")


func _on_compendium_body_entered(body):
	compendium.queue_free()


func _on_Plant_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant/ColorRect")


func _on_Plant2_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant2/ColorRect")


func _on_Plant3_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant3/ColorRect")


func _on_Plant4_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant4/ColorRect")


func _on_Plant5_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant5/ColorRect")


func _on_Plant6_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant6/ColorRect")


func _on_Plant7_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant7/ColorRect")


func _on_Plant8_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant8/ColorRect")


func _on_Plant9_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant9/ColorRect")


func _on_Plant10_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant10/ColorRect")


func _on_Plant11_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant11/ColorRect")


func _on_Plant12_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant12/ColorRect")


func _on_Plant13_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant13/ColorRect")


func _on_Plant14_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant14/ColorRect")


func _on_Plant15_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant15/ColorRect")


func _on_Plant16_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant16/ColorRect")


func _on_Plant17_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant17/ColorRect")


func _on_Plant18_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant18/ColorRect")


func _on_Plant19_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant19/ColorRect")


func _on_Plant20_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant20/ColorRect")


func _on_Plant21_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant21/ColorRect")


func _on_Plant22_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant22/ColorRect")


func _on_Plant23_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant23/ColorRect")


func _on_Plant24_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant24/ColorRect")


func _on_Plant25_body_entered(body):
	plant_sprite = get_node("/root/island/Ground/Garden/Plant25/ColorRect")


func _on_SpawnMob_body_entered(body):
	generate_mob = true


func _on_SpawnMob_body_exited(body):
	generate_mob = false
