extends Panel

var ItemClass = preload("res://Cenas/item.tscn")
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
	if self.name == "slot4":
		item = ItemClass.instance()
		item.create_item(14, "folha")
		add_child(item)
	elif self.name == "slot5":
		item = ItemClass.instance()
		item.create_item(23, "blueflower")
		add_child(item)
	elif self.name == "slot6":
		item = ItemClass.instance()
		item.create_item(5, "emptypot")
		add_child(item)
	elif self.name == "slot7":
		item = ItemClass.instance()
		item.create_item(2, "redflower")
		add_child(item)
	elif self.name == "slot8":
		item = ItemClass.instance()
		item.create_item(1, "ragepot")
		add_child(item)

func pickFromSlot():
	remove_child(item)
	item = null
	
func putIntoSlot(new_item):
	item = new_item
	item.set_position = Vector2(0, 0)
	var inventoryNode = find_parent("inventory")
	add_child(item)

func newItem(nomeItem, quantidadeItem):
	if item == null:
		item = ItemClass
		
func addToSlot():
		item = ItemClass.instance()
		add_child(item)
