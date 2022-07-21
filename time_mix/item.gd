extends Node2D
var nomeItem = "ragepot"
var quantidadeItem = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	#Quando adicionar as imagens substitue o if por essa linha aqui embaixo
	$TextureRect.texture = load("res://Cenas/"+nomeItem+".png")
	var stack = int(JsonItemData.item_data[nomeItem]["Quantity"])
	
	if stack == 1:
		$Label.visible = false
	else:
		$Label.text = String(quantidadeItem)

func add_item(add):
	quantidadeItem += add
	$Label.text = String(quantidadeItem)

func create_item(qtd, nome):
	nomeItem = nome
	quantidadeItem = qtd
