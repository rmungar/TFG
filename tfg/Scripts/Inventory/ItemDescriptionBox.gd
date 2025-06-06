class_name ItemDescriptionBox extends ColorRect


func _on_inv_ui_return_item(item: InventoryItem) -> void:
	if item:
		match item.name:
			"Dash Gem" : $ItemDescription.text = "Allows the user to perform dashes."
			"Double Jump Gem" : $ItemDescription.text = "Allows the user to perform double jumps."
			"Wall Jump Gem" : $ItemDescription.text = "Allows the user to perform wall jumps."
			"DD Gem" : $ItemDescription.text = "Allows the user to perform dashes and double jumps."
			"WD Gem" : $ItemDescription.text = "Allows the user to perform wall jumps and dashes."
			"DW Gem" : $ItemDescription.text = "Allows the user to perform double jumps and wall jumps."
	else:
		get_parent().visible = false


func _on_shop_ui_return_item(item: InventoryItem) -> void:
	if item:
		match item.name:
			"Dash Gem" : $ItemDescription.text = "Allows the user to perform dashes."
			"Double Jump Gem" : $ItemDescription.text = "Allows the user to perform double jumps."
			"Wall Jump Gem" : $ItemDescription.text = "Allows the user to perform wall jumps."
			"DD Gem" : $ItemDescription.text = "Allows the user to perform dashes and double jumps."
			"WD Gem" : $ItemDescription.text = "Allows the user to perform wall jumps and dashes."
			"DW Gem" : $ItemDescription.text = "Allows the user to perform double jumps and wall jumps."
	else:
		get_parent().visible = false
