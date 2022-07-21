extends Panel

var ItemClass = preload("res://item.tscn")
var item = null
var type

# Called when the node enters the scene tree for the first time.
func _ready():
	if self.name == "craft":
		type = "craft"
	elif self.get_parent().name == "Craft":
		type = "craftSlot"
	else:
		type = "inventory"
	if randi()%2 == 0 && type != "craft":
		item = ItemClass.instance()
		add_child(item)

func pickFromSlot():
	remove_child(item)
	item = null
	
func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	var inventoryNode = find_parent("inventory")
	add_child(item)

func newItem(nomeItem, quantidadeItem):
	if item == null:
		item = ItemClass
		
func addToSlot():
		item = ItemClass.instance()
		add_child(item)
