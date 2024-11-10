extends Node

class_name SceneManager

enum LoadMode {SINGLE, ADDITIVE}


func load_scene(scenePath: String, loadMode: LoadMode = LoadMode.SINGLE):
	if(loadMode == LoadMode.SINGLE):
		get_tree().change_scene_to_file(scenePath)
	elif(loadMode == LoadMode.ADDITIVE):
		var scene_trs = load(scenePath)
		add_child(scene_trs)
