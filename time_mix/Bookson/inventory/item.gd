extends Node2D

var nomeItem = "air"
var quantidadeItem = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if randi()%2 == 0:
		nomeItem = "graveto"
	else:
		nomeItem = "folha"
	
	#Quando adicionar as imagens substitue o if por essa linha aqui embaixo
	#$TextureRect.texture = load("res://"+nomeItem+".png")
	if (nomeItem == "folha"):
		$TextureRect.texture = load("res://f_folha.png")
	elif (nomeItem == "graveto"):
		$TextureRect.texture = load("res://g_graveto.png")
	var stack = int(JsonItemData.item_data[nomeItem]["Quantity"])
	quantidadeItem = randi() % stack +1
	
	if stack == 1:
		$Label.visible = false
	else:
		$Label.text = String(quantidadeItem)

func add_item(add):
	quantidadeItem += add
	$Label.text = String(quantidadeItem)
