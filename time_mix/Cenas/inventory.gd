extends Node2D

const SlotClass = preload("res://Cenas/slot.gd")
var ItemClass = preload("res://Cenas/item.tscn").instance()
onready var inventory_slots = $TextureRect/GridContainer
onready var craft_slots = [$Craft/slot1, $Craft/slot2, $Craft/slot3]
onready var craft_result = $Craft/craft
var holding_item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if(Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene("res://Cenas/tutorial.tscn")
	for inv_slot in inventory_slots.get_children():
		inv_slot.connect("gui_input", self, "slot_gui_input", [inv_slot])
	for craft_slot in craft_slots:
		craft_slot.connect("gui_input", self, "slot_gui_input", [craft_slot])
	craft_result.connect("gui_input", self, "slot_gui_input", [craft_result])

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			#segurando item = sim
			if holding_item != null && slot.type != "craft":
				#item no slot = não
				if !slot.item:
					slot.putIntoSlot(holding_item)
					holding_item = null
				#item no slot = sim
				else:
					#item: segurando != slot
					if holding_item.nomeItem != slot.item.nomeItem:
						var temp_item = slot.item
						slot.pickFromSlot()
						temp_item.global_position = event.global_position
						slot.putIntoSlot(holding_item)
						holding_item = temp_item
					#item: segurando == slot
					else:
						var stack = int(JsonItemData.item_data[slot.item.nomeItem]["Quantity"])
						var canAdd = stack - slot.item.quantidadeItem
						if canAdd >= holding_item.quantidadeItem:
							slot.item.add_item(holding_item.quantidadeItem)
							holding_item.queue_free()
							holding_item = null
						else:
							slot.item.add_item(canAdd)
							holding_item.add_item(-canAdd)
			#segurando item = não
			elif slot.item:
				holding_item = slot.item
				slot.pickFromSlot()
				holding_item.global_position = get_global_mouse_position()
				if slot.type == "craft":
					$Craft/slot1.item.add_item(-1)
					if $Craft/slot1.item.quantidadeItem == 0:
						$Craft/slot1.pickFromSlot()
					$Craft/slot2.item.add_item(-1)
					if $Craft/slot2.item.quantidadeItem == 0:
						$Craft/slot2.pickFromSlot()
					$Craft/slot3.item.add_item(-1)
					if $Craft/slot3.item.quantidadeItem == 0:
						$Craft/slot3.pickFromSlot()
		if $Craft/slot1.item != null && $Craft/slot2.item != null && $Craft/slot3.item != null && $Craft/craft.item == null:
			if  $Craft/slot1.item.nomeItem == "emptypot" && $Craft/slot2.item.nomeItem == "blueflower" && $Craft/slot3.item.nomeItem == "folha":
				var temp_item = ItemClass.create_item(1, "defpot")
				$Craft/craft.putIntoSlot(temp_item)
			if  $Craft/slot1.item.nomeItem == "emptypot" && $Craft/slot2.item.nomeItem == "redflower" && $Craft/slot3.item.nomeItem == "folha":
				var temp_item = ItemClass.create_item(1, "ragepot")
				$Craft/craft.putIntoSlot(temp_item)
		elif $Craft/craft.item != null && ($Craft/slot1.item == null || $Craft/slot2.item == null || $Craft/slot3.item == null):
			$Craft/craft.pickFromSlot()
	
func _input(event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
