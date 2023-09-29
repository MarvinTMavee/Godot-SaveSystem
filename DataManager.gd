extends Node

var default_values = { #This is the default save file, it will be used to create a new save file if none is found. Everything written here will also be migrated to the save file
    "version": "1", #<-- Whenever you update the save file, remember to update this value, otherwise the game will not migrate the data which can cause issues accessing non existing values
    "player_name": "Player",
    "player_level": 1,
    "player_exp": 0,
    "player_position": {
        "x": 0,
        "y": 0
    }
}

func saveInit(): #This shall be run on game start
    if not FileAccess.file_exists("user://save.data"):
        var file = FileAccess.open("user://save.data", FileAccess.WRITE)
        file.store_string(JSON.stringify(default_values))
        print("Created new save file")
    else:
        print("Save file found")
        dataMigration(default_values["version"])

func getData(key):
    var raw_data = FileAccess.open("user://save.data", FileAccess.READ).get_as_text(true)
    var current_save = JSON.parse_string(raw_data)
    if current_save.has(key):
        return current_save[key]
    else:
        print("Key %s not found" % key)
        return null

func saveData(key, value):
    var raw_data = FileAccess.open("user://save.data", FileAccess.READ).get_as_text(true)
    var current_save = JSON.parse_string(raw_data)
    var updated_dict = current_save.duplicate()
    updated_dict[key] = value
    var file = FileAccess.open("user://save.data", FileAccess.WRITE)
    file.store_string(JSON.stringify(updated_dict))
    print("Saved %s as %s" % [key, value])

func dataMigration(version): #This will be used to migrate data from older save files to newer ones
	if version == saveVersion:
		print("No migration neccesarry")
	
	else:
		var mraw_data = FileAccess.open("user://save.data", FileAccess.READ).get_as_text(true)
		var current_save = JSON.parse_string(mraw_data)
		var updated_dict = current_save.duplicate()
		for key in default_values.keys():
			if not updated_dict.has(key):
				updated_dict[key] = default_values[key]
				print("Updated key: %s" % key)
				updated_dict["version"] = default_values["version"]
				print("Save Version updated to: %s" % saveVersion)
				var file = FileAccess.open("user://save.data", FileAccess.WRITE)
				file.store_string(JSON.stringify(updated_dict))
