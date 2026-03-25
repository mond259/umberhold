extends Node2D

func _ready():
	var data = JsonDataManager.load_json("res://data/player_stats.json")
	
	if data and data.has("characters"):
		print("--- UMBERHOLD ONLINE ---")
		# Get the very first character from your list
		var first_char = data["characters"][0]
		var char_id = first_char["id"]
		var char_stats = first_char["stats"]
		
		print("Found Character: ", char_id)
		print("STR Stat: ", char_stats["STR"])
		print("LCK Stat: ", char_stats["LCK"])
	else:
		print("❌ ERROR: JSON format mismatch or file not found!")
