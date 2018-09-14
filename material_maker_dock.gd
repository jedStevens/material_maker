tool
extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	$create.connect("pressed", self, "_on_create_pressed")

	$row/src_select.connect("pressed", self, "_on_src_select_pressed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func list_files_in_directory(path):
    var files = []
    var dir = Directory.new()
    dir.open(path)
    dir.list_dir_begin()

    while true:
        var file = dir.get_next()
        if file == "":
            break
        elif not file.begins_with("."):
            files.append(file)

    dir.list_dir_end()

    return files

func _on_src_select_pressed():
	print("Select the folder")
	var folder_selector = $file_dialog
	folder_selector.mode = FileDialog.MODE_OPEN_DIR
	
	folder_selector.connect("dir_selected", self, "_on_dir_selected")
	
	get_tree().root.add_child(folder_selector)
	folder_selector.popup_centered(Vector2(500, 250))
	
func _on_create_pressed():
	print("Creating Material from: ", $row/src_folder.text)
	var src_dir = $row/src_folder.text
	var material = SpatialMaterial.new()
	
	var pngs = list_files_in_directory(src_dir)
	var mat_name = $row/src_folder.text.split("/")[-1]
	for img in pngs:
		if img.ends_with(".png") and img.begins_with(mat_name):
			if img.ends_with("_alb.png"):
				material.albedo_texture = load($row/src_folder.text + "/" + img)
			elif img.ends_with("_rgh.png"):
				material.roughness_texture = load($row/src_folder.text + "/" + img)
			elif img.ends_with("_ao.png"):
				material.ao_texture = load($row/src_folder.text + "/" + img)
			elif img.ends_with("_emi.png"):
				material.emission_texture = load($row/src_folder.text + "/" + img)
			elif img.ends_with("_mtl.png"):
				material.metallic_texture = load($row/src_folder.text + "/" + img)
			else:
				print(img)
	
	if $row2/dst_name.text != "":
		mat_name = $row2/dst_name.text
	ResourceSaver.save($row/src_folder.text + "/" + mat_name +".tres", material)

func _on_dir_selected(dir_name):
	$row/src_folder.text = dir_name