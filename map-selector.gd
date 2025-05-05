#extends VBoxContainer
## Called when the node enters the scene tree for the first time.
#func populateButtons(levels) -> void:
	#for i in range(len(levels)):
		#var button = Button.new()
		#button.text = levels[i].getText()
		#button.pressed.connect(_on_mapbutton_pressed(i))
		#$maps.add_child(button)
#func innerLambda(id: int): 
	#var level = levels[id]
	#if level.path == "random":
		#innerLambda(randi_range(0, len(levels) - 2))
		#return
	#var node = load(level.path).instantiate()
	#node.name = level.name
	#var root = get_tree().root
	#root.remove_child(root.get_child(0))
	#root.add_child(node)#.change_scene_to_file(level.path)
#func _on_mapbutton_pressed(id: int):
	#return func(): innerLambda(id)
